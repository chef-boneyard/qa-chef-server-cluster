
#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: generate-test-data
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

include_recipe 'qa-chef-server-cluster::node-setup'

package 'git'

execute 'git clone https://github.com/chef/chef-server-data-generator.git' do
  cwd '/tmp'
end

generator_dir = "/tmp/chef-server-data-generator"

execute 'git checkout tc/wtf-git-osc-support' do
  cwd generator_dir
end

directory "#{generator_dir}/cookbooks" do
  action :create
end

flavor = node['qa-chef-server-cluster']['chef-server']['flavor']

if flavor == "enterprise_chef"
  ctl_string = "private-chef-ctl"
  server_file = "private-chef.rb"
  server_config_path = "/etc/opscode/"
  knife_config = "knife-in-guest-ec.rb"
  setup_cmd = "setup-ec.sh"
elsif flavor == "chef_server"
  ctl_string = "chef-server-ctl"
  server_file = "chef-server.rb"
  server_config_path = "/etc/opscode/"
  knife_config = "knife-in-guest-ec.rb"
  setup_cmd = "setup-ec.sh"
else
  ctl_string = "chef-server-ctl"
  server_file = "chef-server.rb"
  server_config_path = "/etc/chef-server/"
  knife_config = "knife-in-guest-osc.rb"
  setup_cmd = "setup-osc.sh"
end

cookbook_file "#{generator_dir}/.chef/knife-in-guest.rb" do
  source knife_config
end

file "#{server_config_path}#{server_file}" do
  action :create_if_missing
end

if node['qa-chef-server-cluster']['chef-server']['flavor'] == "enterprise_chef"
  execute "sudo cat private-chef.rb >> #{server_config_path}#{server_file}" do
    cwd generator_dir
  end
end

execute "sudo #{ctl_string} reconfigure"

execute "sudo ./#{setup_cmd}" do
  cwd generator_dir
end
