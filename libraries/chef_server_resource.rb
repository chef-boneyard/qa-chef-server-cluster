# #
# # Author:: Patrick Wright <patrick@chef.io>
# # Copyright (c) 2015, Chef Software, Inc. <legal@chef.io>
# #
# # Licensed under the Apache License, Version 2.0 (the "License");
# # you may not use this file except in compliance with the License.
# # You may obtain a copy of the License at
# #
# #    http://www.apache.org/licenses/LICENSE-2.0
# #
# # Unless required by applicable law or agreed to in writing, software
# # distributed under the License is distributed on an "AS IS" BASIS,
# # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# # See the License for the specific language governing permissions and
# # limitations under the License.
# #

# class Chef::Resource::ChefServer < Chef::Resource::LWRPBase
#   resource_name :chef_server

#   actions :provision, :destroy
#   default_action :provision

#   attribute :server_name, kind_of: String, name_attribute: true

#   attribute :topology, kind_of: String, default: 'standalone' # ha, tier

#   attribute :platform, kind_of: String, default: 'ubuntu' # rhel

#   attribute :platform_version, kind_of: String, default: '14.04' # ...

#   attribute :chef_version, kind_of: String, default: nil

#   attribute :chef_config, kind_of: String, default: nil

#   attribute :chef_flavor, kind_of: String, default: 'chef-server' # open-source-chef enterprise-chef

#   attribute :manage_version, kind_of: String, default: nil

#   attribute :manage_config, kind_of: String, default: nil
# end


# # Chef Server 12 HA (install or upgrade from enterprise or chef server)
# chef_server 'name' do
#   topology 'ha'
#   platform 'ubuntu-14.04'
#   chef_version '12.1.1'
#   # chef_config ''
#   manage_version :latest
#   # manage_config ''
#   # other addons

# # Chef Server 12 Standalone (install or upgrade from all flavors)
# chef_server 'name' do
#   topology 'standalone'
#   platform 'ubuntu-14.04'
#   chef_version '12.1.1'
#   # chef_config ''
#   manage_version :latest
#   # manage_config ''
#   # other addons


# # Open Source Chef
# chef_server 'name' do
#   platform 'ubuntu-14.04'
#   chef_flavor 'open_source_chef'
#   chef_version '11.x'
#   # chef_config '' 
  
# # Enterprise Chef
# chef_server 'name' do
#   topology 'tierw'
#   platform 'ubuntu-14.04'
#   chef_flavor 'enterprise_chef'
#   chef_version '11.x'
#   # chef_config '' 
  
