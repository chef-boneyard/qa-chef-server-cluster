
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

execute 'git clone git@github.com:chef/chef-server-data-generator.git' do
  cwd '/tmp'
end

generator_dir = "/tmp/chef-server-data-generator"

directory "#{generator_dir}/cookbooks" do
  action :create
end

cookbook_file "#{generator_dir}/.chef/knife-in-guest.rb" do
  source 'knife-in-guest.rb'
end

execute "sudo ./setup.sh" do
  cwd generator_dir
end
