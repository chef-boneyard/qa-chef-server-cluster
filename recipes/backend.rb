#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: backend
#
# Author: Joshua Timberman <joshua@getchef.com>
# Author: Patrick Wright <patrick@chef.io>
# Copyright (C) 2015, Chef Software, Inc. <legal@getchef.com>
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

include_recipe 'qa-chef-server-cluster::node-setup'

chef_package current_server.package_name do
  package_url node['qa-chef-server-cluster']['chef-server']['url']
  install_method node['qa-chef-server-cluster']['chef-server']['install_method']
  version node['qa-chef-server-cluster']['chef-server']['version']
  integration_builds node['qa-chef-server-cluster']['chef-server']['integration_builds']
  repository node['qa-chef-server-cluster']['chef-server']['repo']
  config node['chef_server_config']
  reconfigure true
end

file ::File.join(current_server.config_path, 'pivotal.pem') do
  mode 00644
  # without this guard, we create an empty file, causing bootstrap to
  # not actually work, as it checks the presence of this file.
  only_if { ::File.exist?(::File.join(current_server.config_path, 'pivotal.pem')) }
end
