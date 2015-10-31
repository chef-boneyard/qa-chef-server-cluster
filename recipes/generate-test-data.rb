#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: generate-test-data
#
# Author: Tyler Cloke <tyler@chef.io>
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

generator_dir = '/tmp/chef-server-data-generator'

git generator_dir do
  repository 'https://github.com/chef/chef-server-data-generator.git'
  revision node['qa-chef-server-cluster']['data-generator']['branch']
end

directory "#{generator_dir}/cookbooks" do
  action :create
end

case current_server.product_name
when 'enterprise_chef', 'chef_server'
  knife_config = 'knife-in-guest-ec.rb'
  setup_cmd = 'setup-ec.sh'
when 'open_source_chef'
  knife_config = 'knife-in-guest-osc.rb'
  setup_cmd = 'setup-osc.sh'
end

cookbook_file "#{generator_dir}/.chef/knife-in-guest.rb" do
  source knife_config
end

current_config = file ::File.join(current_server.config_path, current_server.config_file) do
  action :create_if_missing
end

execute "sudo cat private-chef.rb >> #{current_config.path}" do
  cwd generator_dir
  only_if { current_server.product_name == 'enterprise_chef' }
end

chef_package current_server.package_name do
  action :reconfigure
end

include_recipe 'qa-chef-server-cluster::chef-server-readiness'

execute "sudo ./#{setup_cmd}" do
  cwd generator_dir
end
