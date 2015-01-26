#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: _standalone-upgrade
#
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

include_recipe 'qa-chef-server-cluster::_default'

execute 'stop services' do
  command 'chef-server-ctl stop'
end

omnibus_artifact 'chef-server' do
  integration_builds true # dervied from cli version
  version :latest # derived from cli version
end

execute 'upgrade server' do
  command 'chef-server-ctl upgrade'
end

execute 'start services' do
  command 'chef-server-ctl start'
end

omnibus_artifact 'opscode-manage' do
  integration_builds true # dervied from cli version
  version '1.7.1' # derived from cli version
end

chef_server_ingredient 'opscode-manage' do
 action :reconfigure
end

chef_server_ingredient 'chef-server-core' do
 action :reconfigure
end

# TODO (pwright) to clean up ot not to clean up (before running pedant)
# execute 'cleanup server' do
#   command 'chef-server-ctl cleanup'
#   action :nothing
# end
