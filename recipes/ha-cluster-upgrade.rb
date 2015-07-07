#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: ha-cluster-upgrade
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

include_recipe 'qa-chef-server-cluster::ha-cluster-setup'


#TODO break all these machine_execute resources into recipes that get added to the run_list
# the I can get rid of all these awful should_install?('chef-server-core') conditions

ctl_command = 'chef-server-ctl'
ctl_command = 'private-chef-ctl' if upgrade_from_flavor == :enterprise_chef

if should_install?('chef-server')
  machine_execute "#{ctl_command} stop" do
    machine node['frontend']
  end

  machine_execute "#{ctl_command} stop keepalived" do
    machine node['secondary-backend']
  end
end

machine_batch do
  machine node['bootstrap-backend'] do
    run_list [ 'qa-chef-server-cluster::ha-install-chef-server-core-package', 'qa-chef-server-cluster::ha-install-chef-ha-package' ]
  end

  machine node['secondary-backend']  do
    run_list [ 'qa-chef-server-cluster::ha-install-chef-server-core-package', 'qa-chef-server-cluster::ha-install-chef-ha-package' ]
  end

  machine node['frontend']  do
    run_list [ 'qa-chef-server-cluster::ha-install-chef-server-core-package' ]
  end
end

if should_install?('chef-server')
  machine_execute "#{ctl_command} stop" do
    machine node['bootstrap-backend']
    retries 1 # http://docs.chef.io/upgrade_server.html#high-availability #7
  end

  machine_execute "#{ctl_command} upgrade" do
    machine node['bootstrap-backend']
  end

  download_bootstrap_files

  machine_batch do
    machine node['frontend'] do
      files node['qa-chef-server-cluster']['chef-server']['files']
    end

    machine node['secondary-backend'] do
      files node['qa-chef-server-cluster']['chef-server']['files']
    end
  end

  machine_execute "#{ctl_command} upgrade" do
    machine node['secondary-backend']
  end

  machine_execute "#{ctl_command} upgrade" do
    machine node['frontend']
  end

  machine_execute "#{ctl_command} start" do
    machine node['frontend']
  end

  machine_execute "#{ctl_command} start" do
    machine node['bootstrap-backend']
  end

  machine_batch do
    machine node['bootstrap-backend'] do
      run_list [ 'qa-chef-server-cluster::ha-verify-backend-master' ]
    end
    machine node['secondary-backend'] do
      run_list [ 'qa-chef-server-cluster::ha-verify-backend-backup' ]
    end
  end
end
