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
      omnibus_artifactory_artifact new_resource.project do
        integration_builds new_resource.integration_builds
        version new_resource.version == 'latest' ? :latest : new_resource.version
      end

      package new_resource.project do
        source omnibus_artifactory_artifact_local_path(new_resource.project)
        provider value_for_platform_family(:debian => Chef::Provider::Package::Dpkg)
        only_if { new_resource.install }
      end
    end
  end
end
