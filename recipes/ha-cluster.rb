#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: ha-cluster
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

# create machines and set attributes
machine_batch do
  machine node['bootstrap-backend'] do
    action :ready
    attribute %w[ chef-server-cluster bootstrap enable ], true
    attribute %w[ chef-server-cluster role ], 'backend'
  end

  machine node['secondary-backend'] do
    action :ready
    attribute %w[ chef-server-cluster bootstrap enable ], false
    attribute %w[ chef-server-cluster role ], 'backend'
  end

  machine node['frontend'] do
    action :ready
    attribute %w[ chef-server-cluster role ], 'frontend'
  end
end

# create and store aws ebs volume
volume = aws_ebs_volume "#{node['qa-chef-server-cluster']['provisioning-id']}-ha" do
  availability_zone "#{node['qa-chef-server-cluster']['aws']['availability_zone']}"
  size 1
  # volume_type :io1
  # iops 300 # size * 30, 3000/4000? max default
  device '/dev/xvdf'
  aws_tags node['qa-chef-server-cluster']['aws']['machine_options']['aws_tags']
end

# create and store aws network interface, all we want is the generated IP
eni = aws_network_interface "#{node['qa-chef-server-cluster']['provisioning-id']}-ha" do
  subnet node['qa-chef-server-cluster']['aws']['machine_options']['bootstrap_options']['subnet_id']
  security_groups node['qa-chef-server-cluster']['aws']['machine_options']['bootstrap_options']['security_group_ids']
  aws_tags node['qa-chef-server-cluster']['aws']['machine_options']['aws_tags']
end

# collect all ha data for chef-server.rb
# TODO aws keys are added to ha_config which sets attributes on the machines
#  this exposes the keys in plain text to the client output. fix this.
ha_config = {}
aws_creds = Chef::Provisioning::AWSDriver::Credentials.new
ha_config[:aws_access_key_id] = aws_creds['default'][:aws_access_key_id]
ha_config[:aws_secret_access_key] = aws_creds['default'][:aws_secret_access_key]
ruby_block 'fetch ebs volume and network interface info' do
  block do
    ha_config[:ebs_volume_id] = search(:aws_ebs_volume, "id:#{volume.name}").first[:reference][:id]
    ha_config[:ebs_device] = volume.device
    ha_config[:eni_ip] = eni.aws_object.private_ip_address
  end
end

# attach volume so the device mount is available to the machine for chef-ha
# TODO https://github.com/chef/chef-provisioning-aws/issues/215
aws_ebs_volume "#{node['qa-chef-server-cluster']['provisioning-id']}-ha" do
  machine node['bootstrap-backend']
  availability_zone "#{node['qa-chef-server-cluster']['aws']['availability_zone']}"
  size 1
  device '/dev/xvdf'
  aws_tags node['qa-chef-server-cluster']['aws']['machine_options']['aws_tags']
end

# destroy network interface, its served its purpose
aws_network_interface "#{node['qa-chef-server-cluster']['provisioning-id']}-ha" do
  action :destroy
end

# converge bootstrap server with all the bits!
machine node['bootstrap-backend'] do
  run_list %w( qa-chef-server-cluster::ha-install-chef-ha-package
               qa-chef-server-cluster::ha-lvm-volume-group
               qa-chef-server-cluster::backend )
  attribute 'qa-chef-server-cluster', node['qa-chef-server-cluster']
  attribute 'ha-config', ha_config
end

download_logs node['bootstrap-backend']

download_bootstrap_files

# converge secondary server with all the bits!
machine node['secondary-backend'] do
  run_list %w(qa-chef-server-cluster::ha-install-chef-ha-package
              lvm
              qa-chef-server-cluster::backend)
  attribute 'qa-chef-server-cluster', node['qa-chef-server-cluster']
  attribute 'ha-config', ha_config
  files node['qa-chef-server-cluster']['chef-server']['files']
end

download_logs node['secondary-backend']

# converge frontend server with all the bits!
machine node['frontend'] do
  run_list [ 'qa-chef-server-cluster::frontend' ]
  attribute 'qa-chef-server-cluster', node['qa-chef-server-cluster']
  attribute 'ha-config', ha_config
  files node['qa-chef-server-cluster']['chef-server']['files']
end

download_logs node['frontend']

machine_batch do
  machine node['bootstrap-backend'] do
    run_list [ 'qa-chef-server-cluster::ha-verify-backend-master' ]
  end
  machine node['secondary-backend'] do
    run_list [ 'qa-chef-server-cluster::ha-verify-backend-backup' ]
  end
end
