#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: tier-cluster
#
# Author: Joshua Timberman <joshua@chef.io>
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

include_recipe 'qa-chef-server-cluster::provisioner-setup'

# set topology if called directly
node.default['qa-chef-server-cluster']['topology'] = 'tier'

machine_batch do
  machine 'bootstrap-backend' do
    action :ready
    attribute 'qa-chef-server-cluster', node['qa-chef-server-cluster']
    attribute %w[ chef-server-cluster bootstrap enable ], true
    attribute %w[ chef-server-cluster role ], 'backend'
  end

  machine 'frontend' do
    action :ready
    attribute 'qa-chef-server-cluster', node['qa-chef-server-cluster']
    attribute %w[ chef-server-cluster role ], 'frontend'
  end
end

machine 'bootstrap-backend' do
  recipe 'qa-chef-server-cluster::backend'
end

# download server files
%w{ actions-source.json webui_priv.pem }.each do |analytics_file|
  machine_file "/etc/opscode-analytics/#{analytics_file}" do
    local_path "#{node['qa-chef-server-cluster']['chef-server']['file-dir']}/#{analytics_file}"
    machine 'bootstrap-backend'
    action :download
  end
end

# download more server files
%w{ pivotal.pem webui_pub.pem private-chef-secrets.json }.each do |opscode_file|
  machine_file "/etc/opscode/#{opscode_file}" do
    local_path "#{node['qa-chef-server-cluster']['chef-server']['file-dir']}/#{opscode_file}"
    machine 'bootstrap-backend'
    action :download
  end
end

machine 'frontend' do
  recipe 'qa-chef-server-cluster::frontend'
  files node['qa-chef-server-cluster']['chef-server']['files']
end
