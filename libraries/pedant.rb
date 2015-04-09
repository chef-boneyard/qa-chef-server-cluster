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
  class Resource::Pedant < Resource::LWRPBase
    self.resource_name = :pedant

    actions :test
    default_action :test

    attribute :machine, name_attribute: true

    # https://github.com/chef/oc-chef-pedant/blob/master/lib/pedant/command_line.rb
    attribute :options
  end

  class Provider::Pedant < Provider::LWRPBase
    action :test do
      machine_execute "chef-server-ctl test #{new_resource.options}" do
        machine new_resource.machine
      end
    end
  end
end
