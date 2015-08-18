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

if current_server.product_name == 'enterprise_chef'
  include_recipe 'qa-chef-server-cluster::ha-enterprise-chef-cluster-upgrade'
  return
end

include_recipe 'qa-chef-server-cluster::ha-cluster-setup'

machine_batch do
  machine node['frontend'] do
    run_list [ 'qa-chef-server-cluster::ha-upgrade-stop-all-services' ]
  end

  machine node['secondary-backend'] do
    run_list [ 'qa-chef-server-cluster::ha-upgrade-stop-keepalived' ]
  end
end

machine_batch do
  machine node['bootstrap-backend'] do
    run_list [ 'qa-chef-server-cluster::ha-install-chef-server-core-package', 'qa-chef-server-cluster::ha-install-chef-ha-package' ]
    attribute 'qa-chef-server-cluster', node['qa-chef-server-cluster']
  end

  machine node['secondary-backend'] do
    run_list [ 'qa-chef-server-cluster::ha-install-chef-server-core-package', 'qa-chef-server-cluster::ha-install-chef-ha-package' ]
    attribute 'qa-chef-server-cluster', node['qa-chef-server-cluster']
  end

  machine node['frontend'] do
    run_list [ 'qa-chef-server-cluster::ha-install-chef-server-core-package' ]
    attribute 'qa-chef-server-cluster', node['qa-chef-server-cluster']
  end
end

machine node['bootstrap-backend'] do
  run_list [ 'qa-chef-server-cluster::ha-upgrade-stop-all-services',
             'qa-chef-server-cluster::ha-upgrade-exec' ]
end

download_bootstrap_files

machine_batch do
  machine node['frontend'] do
    run_list [ 'qa-chef-server-cluster::ha-upgrade-exec' ]
    files node['qa-chef-server-cluster']['chef-server']['files']
  end

  machine node['secondary-backend'] do
    run_list [ 'qa-chef-server-cluster::ha-upgrade-exec' ]
    files node['qa-chef-server-cluster']['chef-server']['files']
  end
end

machine_batch do
  machine node['bootstrap-backend'] do
    run_list [ 'qa-chef-server-cluster::ha-upgrade-start-services' ]
  end

  machine node['frontend'] do
    run_list [ 'qa-chef-server-cluster::ha-upgrade-start-services' ]
  end
end

machine_batch do
  machine node['bootstrap-backend'] do
    run_list [ 'qa-chef-server-cluster::ha-verify-backend-master' ]
  end
  machine node['secondary-backend'] do
    run_list [ 'qa-chef-server-cluster::ha-verify-backend-backup' ]
  end
end
