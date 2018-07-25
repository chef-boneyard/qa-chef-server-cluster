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
  machines node['bootstrap-backend'], node['secondary-backend'], node['frontend']
end

# create and store aws ebs volume
aws_ebs_volume "#{node['qa-chef-server-cluster']['provisioning-id']}-ha" do
  machine node['bootstrap-backend']
  availability_zone node['qa-chef-server-cluster']['aws']['availability_zone']
  size 1
  # volume_type :io1
  # iops 300 # size * 30, 3000/4000? max default
  device '/dev/xvdf'
  aws_tags node['qa-chef-server-cluster']['aws']['machine_options']['aws_tags']
end

# create and store aws network interface, all we want is the generated IP with the same network segment
aws_network_interface "#{node['qa-chef-server-cluster']['provisioning-id']}-ha" do
  subnet node['qa-chef-server-cluster']['aws']['machine_options']['bootstrap_options']['subnet_id']
  security_groups node['qa-chef-server-cluster']['aws']['machine_options']['bootstrap_options']['security_group_ids']
  aws_tags node['qa-chef-server-cluster']['aws']['machine_options']['aws_tags']
end

bootstrap = resources("aws_instance[#{node['bootstrap-backend']}]")
secondary = resources("aws_instance[#{node['secondary-backend']}]")
frontend = resources("aws_instance[#{node['frontend']}]")
eni = resources("aws_network_interface[#{node['qa-chef-server-cluster']['provisioning-id']}-ha]")
volume = resources("aws_ebs_volume[#{node['qa-chef-server-cluster']['provisioning-id']}-ha]")
# Set the profile name as it is on disk when we try to read it in.
ENV['AWS_DEFAULT_PROFILE'] = 'chef-cd'
aws_creds = Chef::Provisioning::AWSDriver::Credentials.new

ruby_block 'HA Chef Server Config' do # ~FC014
  block do
    node.default['qa-chef-server-cluster']['chef-server-config'] = <<-EOS\
topology 'ha'
api_fqdn '#{node['qa-chef-server-cluster']['chef-server']['api_fqdn']}'

ha['provider'] = 'aws'
ha['aws_access_key_id'] = '#{aws_creds['default'][:aws_access_key_id]}'
ha['aws_secret_access_key'] = '#{aws_creds['default'][:aws_secret_access_key]}'
ha['ebs_volume_id'] = '#{volume.aws_object.id}'
ha['ebs_device'] = '#{volume.device}'

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

backend_vip '#{eni.aws_object.private_ip_address}',
  :ipaddress => '#{eni.aws_object.private_ip_address}',
  :device => 'eth0',
  :heartbeat_device => 'eth0'

EOS
  end
end

# destroy network interface, its served its purpose
aws_network_interface "#{node['qa-chef-server-cluster']['provisioning-id']}-ha" do
  action :destroy
end

# converge bootstrap server with all the bits!
machine node['bootstrap-backend'] do
  run_list %w(qa-chef-server-cluster::ha-install-chef-ha-package
              qa-chef-server-cluster::ha-lvm-volume-group
              qa-chef-server-cluster::backend)
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
  run_list %w(qa-chef-server-cluster::ha-install-chef-ha-package
              lvm
              qa-chef-server-cluster::backend)
  attributes lazy {
    {
      'qa-chef-server-cluster' => node['qa-chef-server-cluster']
    }
  }
  files lazy { filter_existing_files node['qa-chef-server-cluster']['chef-server']['files'] }
end

download_logs node['secondary-backend']

# converge frontend server with all the bits!
machine node['frontend'] do
  run_list ['qa-chef-server-cluster::frontend']
  attributes lazy {
    {
      'qa-chef-server-cluster' => node['qa-chef-server-cluster']
    }
  }
  files lazy { filter_existing_files node['qa-chef-server-cluster']['chef-server']['files'] }
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
