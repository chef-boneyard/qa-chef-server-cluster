#
# Cookbook Name:: qa-chef-server-cluster
# Recipes: :tier-cluster-upgrade
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

include_recipe 'qa-chef-server-cluster::provisioner-setup'

# set topology if called directly
node.default['qa-chef-server-cluster']['chef-server']['topology'] = 'tier'

machine 'bootstrap-backend' do
  run_list [ 'qa-chef-server-cluster::backend-upgrade' ]
  attribute 'qa-chef-server-cluster', node['qa-chef-server-cluster']
end

download_logs 'bootstrap-backend'

machine 'frontend' do
  run_list [ 'qa-chef-server-cluster::frontend-upgrade' ]
  attribute 'qa-chef-server-cluster', node['qa-chef-server-cluster']
end

download_logs 'frontend'
