#
# Author:: Patrick Wright <patrick@chef.io>
# Copyright (c) 2015, Chef Software, Inc. <legal@chef.io>
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
  class Resource
    class ChefPackage < Chef::Resource::LWRPBase
      resource_name :chef_package

      actions :install, :upgrade, :reconfigure
      default_action :install

      # name of the project
      attribute :product_name, kind_of: String, name_attribute: true

      # run reconfigure after install or upgrade
      attribute :reconfigure, kind_of: [TrueClass, FalseClass], default: false

      # chef_ingredient config
      attribute :config, kind_of: String, default: nil

      # installation method
      attribute :install_method, kind_of: String, default: nil, equal_to: %w( artifactory packagecloud chef-server-ctl )

      # Attribute to install package from remote file
      attribute :package_url, kind_of: String, default: nil

      # Shared version for install methods
      attribute :version, kind_of: [String, Symbol], default: nil

      # Artifactory specific
      attribute :integration_builds, kind_of: [TrueClass, FalseClass, NilClass], default: nil

      # Artifactory specific
      attribute :repository, kind_of: String, default: nil
    end
  end
end
