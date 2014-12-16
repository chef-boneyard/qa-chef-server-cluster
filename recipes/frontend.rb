#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: frontend
#
# Author: Joshua Timberman <joshua@getchef.com>
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
directory '/etc/opscode' do
  mode 0755
  recursive true
end

include_recipe 'chef-vault'

node.default['chef-server-cluster']['role'] = 'frontend'

# TODO: (jtimberman) chef_vault_item. We sort this so we don't
# get regenerated content in the private-chef-secrets.json later.
chef_secrets = Hash[data_bag_item('secrets', "private-chef-secrets-#{node.chef_environment}")['data'].sort]

# It's easier to deal with a hash rather than a data bag item, since
# we're not going to need any of the methods, we just need raw data.
chef_server_config = data_bag_item('chef_server', 'topology').to_hash
chef_server_config.delete('id')

# TODO: (jtimberman) Replace this with partial search.
chef_servers = search('node', 'chef-server-cluster_role:backend').map do |server| #~FC003
  {
    :fqdn => server['fqdn'],
    :ipaddress => server['ipaddress'],
    :bootstrap => server['chef-server-cluster']['bootstrap']['enable'],
    :role => server['chef-server-cluster']['role']
  }
end

chef_servers << {
               :fqdn => node['fqdn'],
               :ipaddress => node['ipaddress'],
               :bootstrap => false,
               :role => 'frontend'
              }

node.default['chef-server-cluster'].merge!(chef_server_config)

file '/etc/opscode/private-chef-secrets.json' do
  content JSON.pretty_generate(chef_secrets)
  notifies :reconfigure, 'chef_server_ingredient[chef-server-core]'
  sensitive true
end

template '/etc/opscode/chef-server.rb' do
  cookbook 'chef-server-cluster'
  source 'chef-server.rb.erb'
  variables :chef_server_config => node['chef-server-cluster'], :chef_servers => chef_servers
  notifies :reconfigure, 'chef_server_ingredient[chef-server-core]'
end

opscode_manage_source   = node['qa-chef-server-cluster']['opscode-manage']['source']

if opscode_manage_source
  remote_file '/tmp/opscode-manage.deb' do
    source opscode_manage_source
  end

  # fix when we support another platform
  dpk_package 'opscode-manage' do
    source '/tmp/opscode-manage.deb'
  end
else
  # use ctl or not?  using ingredient we get more version control
  chef_server_ingredient 'opscode-manage' do
    version node['qa-chef-server-cluster']['opscode-manage']['version']
  end
end

chef_server_ingredient 'opscode-manage' do
  action :reconfigure
end
