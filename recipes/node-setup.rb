#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: node-setup
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

directory '/etc/opscode' do
  mode 0755
  recursive true
end

directory '/etc/chef-server' do
  mode 0755
  recursive true
end

include_recipe 'apt::default'
include_recipe 'build-essential::default'

chef_server_ingredient 'chef-server-core' do
  action :nothing
end

chef_server_ingredient 'opscode-manage' do
  action :nothing
end

service 'iptables' do
  action [ :disable, :stop ]
  only_if { platform_family?('rhel') }
end

# rhel 5 does not support ssl protocol SNI
# for simplification, all rhel version import the key locally
gpg_key = ::File.join(Chef::Config[:file_cache_path], 'packages-chef-io-public.key')
remote_file gpg_key do
  source "https://downloads.chef.io/packages-chef-io-public.key"
  only_if { platform_family?('rhel') }
end

execute 'import keys for rhel' do
  command "rpm --import #{gpg_key}"
  only_if { platform_family?('rhel') }
end
