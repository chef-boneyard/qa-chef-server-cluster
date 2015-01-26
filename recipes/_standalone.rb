#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: _standalone
#
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

include_recipe 'qa-chef-server-cluster::_default'

omnibus_artifact 'chef-server' do
  integration_builds node['qa-chef-server-cluster']['chef-server']['install']['integration_builds']
  version node['qa-chef-server-cluster']['chef-server']['install']['version']
end

chef_server_ingredient 'chef-server-core' do
  action :reconfigure
end

if node['qa-chef-server-cluster']['manage']['install']['version']
  omnibus_artifact 'opscode-manage' do
    integration_builds node['qa-chef-server-cluster']['manage']['install']['integration_builds']
    version node['qa-chef-server-cluster']['manage']['install']['version']
  end

  chef_server_ingredient 'opscode-manage' do
   action :reconfigure
  end

  chef_server_ingredient 'chef-server-core' do
   action :reconfigure
  end
end
