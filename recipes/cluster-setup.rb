#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: _cluster-setup
#
# Author: Joshua Timberman <joshua@getchef.com>
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

require 'chef/provisioning/aws_driver'

# This requires that the desired AWS account to use is configured in
# ~/.aws/config as `default`.
with_driver("aws::#{node['qa-chef-server-cluster']['aws']['region']}")

provisioner_machine_opts = node['qa-chef-server-cluster']['aws']['machine_options'].to_hash
ChefHelpers.symbolize_keys_deep!(provisioner_machine_opts)

with_machine_options(provisioner_machine_opts)

ssh_keys = data_bag_item('secrets', node['qa-chef-server-cluster']['chef-provisioner-key-name'])

directory '/tmp/ssh' do
  recursive true
end

directory '/tmp/stash' do
  recursive true
end

file '/tmp/ssh/id_rsa' do
  content ssh_keys['private_ssh_key']
  sensitive true
end

file '/tmp/ssh/id_rsa.pub' do
  content ssh_keys['public_ssh_key']
  sensitive true
end
#
aws_key_pair node['qa-chef-server-cluster']['aws']['machine_options']['bootstrap_options']['key_name'] do
  private_key_path '/tmp/ssh/id_rsa'
  public_key_path '/tmp/ssh/id_rsa.pub'
end

