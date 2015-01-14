#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: standalone-provision
#
# Author: Joshua Timberman <joshua@chef.io>
# Author: Patrick Wright <patrick@chef.io>
# Copyright (C) 2014, Chef Software, Inc. <legal@getchef.com>
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

# TODO (pwright) Move to similar default recipe
directory '/etc/opscode' do
  mode 0755
  recursive true
end

chef_server_core_source = node['qa-chef-server-cluster']['chef-server-core']['source']
opscode_manage_source   = node['qa-chef-server-cluster']['opscode-manage']['source']

chef_server_core_path = File.join(Chef::Config[:file_cache_path], File.basename(chef_server_core_source))

remote_file chef_server_core_path do
  source chef_server_core_source
end

package 'chef-server-core' do
  source chef_server_core_path
  provider value_for_platform_family(:debian => Chef::Provider::Package::Dpkg, :rhel => Chef::Provider::Package::Rpm)
end

chef_server_ingredient 'chef-server-core' do
  action :reconfigure
end

# # TODO (pwright) refactor into a LWRP class
# if opscode_manage_source
#   opscode_manage_path = File.join(Chef::Config[:file_cache_path], File.basename(opscode_manage_source))

#   remote_file opscode_manage_path do
#     source opscode_manage_source
#   end

#   package 'opscode-manage' do
#     source opscode_manage_path
#     provider value_for_platform_family(:debian => Chef::Provider::Package::Dpkg, :rhel => Chef::Provider::Package::Rpm)
#     notifies :reconfigure, 'chef_server_ingredient[opscode-manage]'
#   end
# else
#   chef_server_ingredient 'opscode-manage' do
#     notifies :reconfigure, 'chef_server_ingredient[opscode-manage]'
#   end
# end
