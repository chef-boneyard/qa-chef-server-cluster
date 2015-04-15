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

machine_execute 'chef-server-ctl stop' do
  machine 'frontend'
end

machine_execute 'chef-server-ctl stop keepalived' do
  machine 'secondary-backend'
end

machine_batch do
  machine 'bootstrap-backend' do
    # recipe 'qa-chef-server-cluster::chef-ha-upgrade-package'
    recipe 'qa-chef-server-cluster::chef-server-core-upgrade-package'
  end

  machine 'secondary-backend' do
    # recipe 'qa-chef-server-cluster::chef-ha-upgrade-package'
    recipe 'qa-chef-server-cluster::chef-server-core-upgrade-package'
  end

  machine 'frontend' do
    recipe 'qa-chef-server-cluster::chef-server-core-upgrade-package'
  end
end

machine_execute 'chef-server-ctl stop' do
  machine 'bootstrap-backend'
  retries 1 # http://docs.chef.io/upgrade_server.html#high-availability #7
end

machine_execute 'chef-server-ctl upgrade' do
  machine 'bootstrap-backend'
end

download_bootstrap_files

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
