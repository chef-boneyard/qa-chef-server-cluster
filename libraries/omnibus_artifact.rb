#
# Author: Patrick Wright <patrick@chef.io>
# Copyright (C) 2015, Chef Software, Inc. <legal@chef.io>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class Chef
  class Resource::OmnibusArtifact < Resource::LWRPBase
    self.resource_name = :omnibus_artifact

    actions :default
    default_action :default

    attribute :project,             name_attribute: true
    attribute :version,             kind_of: [String, Symbol]
    attribute :integration_builds,  kind_of: [TrueClass, FalseClass]
    attribute :install,             kind_of: [TrueClass, FalseClass], default: true
  end

  class Provider::OmnibusArtifact < Provider::LWRPBase
    action(:default) do
      new_version = new_resource.version
      new_version = :latest if new_resource.version == 'latest'

      artifact = omnibus_artifactory_artifact path do
        project new_resource.project
        integration_builds new_resource.integration_builds
        version new_version
        platform value_for_platform_family(:debian => 'ubuntu', :rhel => 'el')
        platform_version value_for_platform_family(:debian => node['platform_version'], :rhel => node['platform_version'][0])
      end

      if new_resource.install
        converge_by("Install #{path}") do
          properties = artifact.properties

          # rhel 5 does not support ssl protocol SNI
          # for simplification, all rhel version import the key locally
          gpg_key = ::File.join(Chef::Config[:file_cache_path], 'packages-chef-io-public.key')
          remote_file gpg_key do
            source "https://downloads.chef.io/packages-chef-io-public.key"
            only_if { platform_family?('rhel') }
          end

          execute 'import keys for rhel' do
            command "rpm --import #{gpg_key}"
            only_if { platform_family?('rhel') }
          end

          package ::File.basename(path) do
            source path
            provider value_for_platform_family(:debian => Chef::Provider::Package::Dpkg)
            version "#{properties['omnibus.version']}-#{properties['omnibus.iteration']}"
          end
        end
      end
    end

    def path
      @path ||= ::File.join(Chef::Config[:file_cache_path],
        "#{new_resource.project}#{value_for_platform_family(:debian => '.deb', :rhel => '.rpm')}")
    end
  end
end
