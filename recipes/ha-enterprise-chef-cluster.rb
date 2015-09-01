#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: ha-enterprise-chef-cluster
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

# UBUNTU 12.04 ONLY UNTIL REQUIRED

include_recipe 'qa-chef-server-cluster::ha-cluster-setup'

# create machines and set attributes
machine_batch do
  machines node['bootstrap-backend'], node['secondary-backend'], node['frontend']
end

# create and store aws ebs volume
volume = aws_ebs_volume "#{node['qa-chef-server-cluster']['provisioning-id']}-ha" do
  machine node['bootstrap-backend']
  availability_zone node['qa-chef-server-cluster']['aws']['availability_zone']
  size 8
  # volume_type :io1
  # iops 300 # size * 30, 3000/4000? max default
  device '/dev/xvdf'
  aws_tags node['qa-chef-server-cluster']['aws']['machine_options']['aws_tags']
end

aws_ebs_volume "#{node['qa-chef-server-cluster']['provisioning-id']}-ha-secondary" do
  machine node['secondary-backend']
  availability_zone node['qa-chef-server-cluster']['aws']['availability_zone']
  size 8
  # volume_type :io1
  # iops 300 # size * 30, 3000/4000? max default
  device '/dev/xvdf'
  aws_tags node['qa-chef-server-cluster']['aws']['machine_options']['aws_tags']
end

bootstrap = resources("aws_instance[#{node['bootstrap-backend']}]")
secondary = resources("aws_instance[#{node['secondary-backend']}]")
frontend = resources("aws_instance[#{node['frontend']}]")

ruby_block 'server block info' do
  block do
    node.default['qa-chef-server-cluster']['chef-server-config'] = "\
topology 'ha'
api_fqdn '#{node['qa-chef-server-cluster']['chef-server']['api_fqdn']}'

server '#{bootstrap.aws_object.private_dns_name}',
  :ipaddress => '#{bootstrap.aws_object.private_ip_address}',
  :bootstrap => true,
  :role => 'backend'

server '#{secondary.aws_object.private_dns_name}',
  :ipaddress => '#{secondary.aws_object.private_ip_address}',
  :role => 'backend'

server '#{frontend.aws_object.private_dns_name}',
  :ipaddress => '#{frontend.aws_object.private_ip_address}',
  :role => 'frontend'

backend_vip '44.44.100.99',
  :ipaddress => '44.44.100.99',
  :device => 'eth0'

"
  end
end

# converge bootstrap server with all the bits!
machine node['bootstrap-backend'] do
  run_list %w(qa-chef-server-cluster::ha-enterprise-chef-lvm-volume-group
              qa-chef-server-cluster::ha-enterprise-chef-backend)
  attributes lazy {
    {
      'qa-chef-server-cluster' => node['qa-chef-server-cluster'],
      'lvm_phyiscal_volume' => volume.device
    }
  }
end

download_logs node['bootstrap-backend']

download_bootstrap_files

# converge secondary server with all the bits!
machine node['secondary-backend'] do
  run_list %w(qa-chef-server-cluster::ha-enterprise-chef-lvm-volume-group
              qa-chef-server-cluster::ha-enterprise-chef-backend)
  attributes lazy {
    {
      'qa-chef-server-cluster' => node['qa-chef-server-cluster'],
      'lvm_phyiscal_volume' => volume.device
    }
  }
  files node['qa-chef-server-cluster']['chef-server']['files']
end

download_logs node['secondary-backend']

machine node['bootstrap-backend'] do
  run_list %w(qa-chef-server-cluster::ha-enterprise-chef-drbd-sync
              qa-chef-server-cluster::ha-enterprise-chef-drbd-ready)
  attributes {
    { 'qa-chef-server-cluster' => node['qa-chef-server-cluster'] }
  }
end

machine node['secondary-backend'] do
  run_list %w(qa-chef-server-cluster::ha-enterprise-chef-drbd-ready)
  attributes {
    { 'qa-chef-server-cluster' => node['qa-chef-server-cluster'] }
  }
end

# converge frontend server with all the bits!
machine node['frontend'] do
  run_list ['qa-chef-server-cluster::ha-enterprise-chef-frontend']
  attributes lazy {
    {
      'qa-chef-server-cluster' => node['qa-chef-server-cluster']
    }
  }
  files node['qa-chef-server-cluster']['chef-server']['files']
end

download_logs node['frontend']

machine_batch do
  machine node['bootstrap-backend'] do
    run_list ['qa-chef-server-cluster::ha-verify-backend-master']
  end
  machine node['secondary-backend'] do
    run_list ['qa-chef-server-cluster::ha-verify-backend-backup']
  end
end
