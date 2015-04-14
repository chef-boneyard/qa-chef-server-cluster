#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: ha-cluster-upgrade
#
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
node.default['qa-chef-server-cluster']['topology'] = 'ha'

#  #stop_frontends
machine_execute 'chef-server-ctl stop' do
  machine 'frontend'
end

#  #stop_keepalived(machine = :secondary)
machine_execute 'chef-server-ctl stop keepalived' do
  machine 'secondary-backend'
end

#  #upgrade_servers
machine_batch do
  machine 'bootstrap-backend' do
    recipe 'qa-chef-server-cluster::chef-server-core-upgrade-package'
  end

  machine 'secondary-backend' do
    recipe 'qa-chef-server-cluster::chef-server-core-upgrade-package'
  end

  machine 'frontend' do
    recipe 'qa-chef-server-cluster::chef-server-core-upgrade-package'
  end
end

#  #stop
machine_execute 'chef-server-ctl stop' do
  machine 'bootstrap-backend'
  retries 1 # http://docs.chef.io/upgrade_server.html#high-availability #7
end

machine_execute 'chef-server-ctl upgrade' do
  machine 'bootstrap-backend'
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

# upload to secondary and frontend
machine_batch do
  machine 'frontend' do
    files node['qa-chef-server-cluster']['chef-server']['files']
  end

  machine 'secondary-backend' do
    files node['qa-chef-server-cluster']['chef-server']['files']
  end
end

machine_execute 'chef-server-ctl upgrade' do
  machine 'secondary-backend'
end

machine_execute 'chef-server-ctl upgrade' do
  machine 'frontend'
end

machine_execute 'chef-server-ctl start' do
  machine 'frontend'
end

machine_execute 'chef-server-ctl start' do
  machine 'bootstrap-backend'
end
