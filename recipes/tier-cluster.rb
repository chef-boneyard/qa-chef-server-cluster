#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: tier-cluster
#
# Author: Joshua Timberman <joshua@chef.io>
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

include_recipe 'qa-chef-server-cluster::tier-cluster-setup'

machine_batch do
  machine node['bootstrap-backend'] do
    action :ready
    attribute 'qa-chef-server-cluster', node['qa-chef-server-cluster']
    attribute %w(chef-server-cluster bootstrap enable), true
    attribute %w(chef-server-cluster role), 'backend'
  end

  machine node['frontend'] do
    action :ready
    attribute 'qa-chef-server-cluster', node['qa-chef-server-cluster']
    attribute %w(chef-server-cluster role), 'frontend'
  end
end

bootstrap = resources("aws_instance[#{node['bootstrap-backend']}]")
frontend = resources("aws_instance[#{node['frontend']}]")

ruby_block 'server block info' do
  block do
    chef_server_config << "\
topology 'tier'
api_fqdn '#{node['qa-chef-server-cluster']['chef-server']['api_fqdn']}'

server '#{bootstrap.aws_object.private_dns_name}',
  :ipaddress => '#{bootstrap.aws_object.private_ip_address}',
  :bootstrap => true,
  :role => 'backend'

server '#{frontend.aws_object.private_dns_name}',
  :ipaddress => '#{frontend.aws_object.private_ip_address}',
  :role => 'frontend'

backend_vip '#{bootstrap.aws_object.private_dns_name}',
  :ipaddress => '#{bootstrap.aws_object.private_ip_address}'

"
  end
end

machine node['bootstrap-backend'] do
  run_list ['qa-chef-server-cluster::backend']
  attributes lazy {
    {
      'chef_server_config' => chef_server_config
    }
  }
end

download_logs node['bootstrap-backend']

download_bootstrap_files

machine node['frontend'] do
  run_list ['qa-chef-server-cluster::frontend']
  files node['qa-chef-server-cluster']['chef-server']['files']
  attributes lazy {
    {
      'chef_server_config' => chef_server_config
    }
  }
end

download_logs node['frontend']
