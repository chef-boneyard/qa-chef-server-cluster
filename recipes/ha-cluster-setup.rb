#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: ha-cluster-setup
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

node.default['qa-chef-server-cluster']['topology'] = 'ha'

node.default['bootstrap-backend'] = "#{node['qa-chef-server-cluster']['provisioning-id']}-ha-bootstrap-backend"
node.default['secondary-backend'] = "#{node['qa-chef-server-cluster']['provisioning-id']}-ha-secondary-backend"
node.default['frontend'] = "#{node['qa-chef-server-cluster']['provisioning-id']}-ha-frontend"

# Define the aws_instance resource and managed machine resources
[
  node['bootstrap-backend'],
  node['secondary-backend'],
  node['frontend']
].each do |name|
  aws_instance name do
    action :nothing
  end
end
