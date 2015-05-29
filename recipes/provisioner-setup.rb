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

keys_dir = File.join(Chef::Config[:chef_repo_path], '.chef', 'keys')
directory keys_dir do
  mode 0700
  recursive true
end

chef_server_files_dir = node.default['qa-chef-server-cluster']['chef-server']['file-dir'] = File.join(Chef::Config[:chef_repo_path],
                                                                                                      '.chef', 'stash')

directory node['qa-chef-server-cluster']['chef-server']['file-dir'] do
  mode 0700
  recursive true
end

priv_key = File.join(keys_dir, 'id_rsa')
file priv_key do
  mode 0600
  content ssh_keys['private_ssh_key']
  sensitive true
end

pub_key = File.join(keys_dir, 'id_rsa.pub')
file pub_key do
  mode 0600
  content ssh_keys['public_ssh_key']
  sensitive true
end

aws_key_pair node['qa-chef-server-cluster']['aws']['machine_options']['bootstrap_options']['key_name'] do
  private_key_path priv_key
  public_key_path pub_key
end

# set attribute so clusters know where to find bootstrapped server files
node.default['qa-chef-server-cluster']['chef-server']['files'] = {
  '/etc/opscode/webui_priv.pem' => "#{chef_server_files_dir}/webui_priv.pem",
  '/etc/opscode/webui_pub.pem' => "#{chef_server_files_dir}/webui_pub.pem",
  '/etc/opscode/pivotal.pem' => "#{chef_server_files_dir}/pivotal.pem",
  '/etc/opscode/private-chef-secrets.json' => "#{chef_server_files_dir}/private-chef-secrets.json"
}
