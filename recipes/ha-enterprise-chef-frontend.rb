#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: frontend
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

chef_package current_server.package_name do
  package_url node['qa-chef-server-cluster']['chef-server']['url']
  install_method node['qa-chef-server-cluster']['chef-server']['install_method']
  version node['qa-chef-server-cluster']['chef-server']['version']
  integration_builds node['qa-chef-server-cluster']['chef-server']['integration_builds']
  repository node['qa-chef-server-cluster']['chef-server']['repo']
end


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
               :role => 'frontend'
              }

node.default['chef-server-cluster'].merge!(node['qa-chef-server-cluster']['chef-server'])

template ::File.join(current_server.config_path, current_server.config_file) do
  source 'private-chef-ha.rb.erb'
  variables :chef_server_config => node['chef-server-cluster'],
            :topology => node['qa-chef-server-cluster']['topology'],
            :chef_servers => chef_servers,
            :ha_config => node['ha-config']
  notifies :run, 'execute[add hosts entry]'
end

chef_package current_server.package_name do
  action :reconfigure
  not_if { node['qa-chef-server-cluster']['chef-server']['version'].nil? }
end

chef_package 'manage' do
  package_url node['qa-chef-server-cluster']['opscode-manage']['url']
  install_method node['qa-chef-server-cluster']['opscode-manage']['install_method']
  version node['qa-chef-server-cluster']['opscode-manage']['version']
  integration_builds node['qa-chef-server-cluster']['opscode-manage']['integration_builds']
  repository node['qa-chef-server-cluster']['opscode-manage']['repo']
  reconfigure true
  not_if { current_server.product_name == 'open_source_chef' }
end

# TODO (pwright) Run again for all I care!!!  Not really.  Temp hack for lack of dns
execute 'add hosts entry' do
  command "echo '#{node['ipaddress']} #{node['qa-chef-server-cluster']['chef-server']['api_fqdn']}' >> /etc/hosts"
  action :nothing
end

# TODO check this out from chef-server cookbook
# ruby_block 'ensure node can resolve API FQDN' do
#   extend ChefServerCoobook::Helpers
#   block { repair_api_fqdn }
#   only_if { api_fqdn_node_attr }
#   not_if { api_fqdn_resolves }
# end
