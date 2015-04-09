#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: ha-cluster
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

# set topology
node.default['qa-chef-server-cluster']['topology'] = 'ha'


# Stop all of the front end machines:
#
#     $ chef-server-ctl stop

# Stop Keepalived on the original non-bootstrap backend machine. This will ensure that the bootstrap back end machine is the active machine. This action may trigger a failover.
#
# $ chef-server-ctl stop keepalived

# install server package on all machines

# On the primary back end machine, stop all services except Keepalived. With Chef server 12, the Keepalived service will not be stopped with the following command:
#
# $ chef-server-ctl stop


# If the upgrade process times out, re-run the command until it finishes successfully. ?????

# Upgrade the back end primary machine with the following command:
#
# $ chef-server-ctl upgrade


# what do we actually need here?
# Copy the entire /etc/opscode directory from the back end primary machine to all front and back end nodes. For example, from each server run:
#
# $ scp -r <Bootstrap server IP>:/etc/opscode /etc
# or from the back end primary machine:
#
# $ scp -r /etc/opscode <each servers IP>:/etc

# Upgrade the back end secondary machine with the following command:
#
# $ chef-server-ctl upgrade

# In some instances, after the upgrade processes is complete, it may be required to stop Keepalived on the back end secondary machine, then restart Keepalived on the back end primary machine, and then restart Keepalived on the back end secondary machine.

# Upgrade all front end machines with the following commands:
#
# $ chef-server-ctl upgrade

# Run the following command on all front end machines and the primary back end machine:
#
#     $ chef-server-ctl start
# Do not run this command on the secondary back-end machine!

#
# After the upgrade process is complete, the state of the system after the upgrade has been tested and verified, and everything looks satisfactory, remove old data, services, and configuration by running the following command on each machine:
#
# $ chef-server-ctl cleanup







# # create machines and set attributes
# machine_batch do
#   machine 'bootstrap-backend' do
#     attribute %w[ chef-server-cluster bootstrap enable ], true
#     attribute %w[ chef-server-cluster role ], 'backend'
#     attribute 'qa-chef-server-cluster', node['qa-chef-server-cluster']
#   end
#
#   machine 'secondary-backend' do
#     attribute %w[ chef-server-cluster bootstrap enable ], false
#     attribute %w[ chef-server-cluster role ], 'backend'
#     attribute 'qa-chef-server-cluster', node['qa-chef-server-cluster']
#   end
#
#   machine 'frontend' do
#     attribute %w[ chef-server-cluster role ], 'frontend'
#     attribute 'qa-chef-server-cluster', node['qa-chef-server-cluster']
#   end
# end
#
# # create and store aws ebs volume
# volume = aws_ebs_volume 'ha-ebs' do
#   availability_zone "#{node['qa-chef-server-cluster']['aws']['region']}#{node['qa-chef-server-cluster']['aws']['availability_zone']}"
#   size 1
#   # volume_type :io1
#   # iops 300 # size * 30, 3000/4000? max default
#   device '/dev/xvdf'
# end
#
# # create and store aws network interface, all we want is the generated IP
# eni = aws_network_interface 'ha-eni' do
#   subnet node['qa-chef-server-cluster']['aws']['machine_options']['bootstrap_options']['subnet_id']
#   security_groups node['qa-chef-server-cluster']['aws']['machine_options']['bootstrap_options']['security_group_ids']
# end
#
# # collect all ha data for chef-server.rb
# # TODO aws keys are added to ha_config which sets attributes on the machines
# #  this exposes the keys in plain text to the client output. fix this.
# ha_config = {}
# aws_creds = Chef::Provisioning::AWSDriver::Credentials.new
# ha_config[:aws_access_key_id] = aws_creds['default'][:aws_access_key_id]
# ha_config[:aws_secret_access_key] = aws_creds['default'][:aws_secret_access_key]
# ruby_block 'fetch ebs volume and network interface info' do
#   block do
#     ha_config[:ebs_volume_id] = search(:aws_ebs_volume, "id:#{volume.name}").first[:reference][:id]
#     ha_config[:ebs_device] = volume.device
#     ha_config[:eni_ip] = eni.aws_object.private_ip_address
#   end
# end
#
# # destroy network interface, its served its purpose
# aws_network_interface 'ha-eni' do
#   action :destroy
# end
#
# # attach volume so the device mount is available to the machine for chef-ha
# aws_ebs_volume 'ha-ebs' do
#   machine 'bootstrap-backend'
# end
#
# # converge bootstrap server with all the bits!
# machine 'bootstrap-backend' do
#   recipe 'qa-chef-server-cluster::_chef-ha'
#   recipe 'qa-chef-server-cluster::lvm_volume_group'
#   recipe 'qa-chef-server-cluster::_backend'
#   attribute 'ha-config', ha_config
# end
#
# # download server files
# %w{ actions-source.json webui_priv.pem }.each do |analytics_file|
#   machine_file "/etc/opscode-analytics/#{analytics_file}" do
#     local_path "/tmp/stash/#{analytics_file}"
#     machine 'bootstrap-backend'
#     action :download
#   end
# end
#
# # download more server files
# %w{ pivotal.pem webui_pub.pem private-chef-secrets.json }.each do |opscode_file|
#   machine_file "/etc/opscode/#{opscode_file}" do
#     local_path "/tmp/stash/#{opscode_file}"
#     machine 'bootstrap-backend'
#     action :download
#   end
# end
#
# # converge secondary server with all the bits!
# machine 'secondary-backend' do
#   recipe 'qa-chef-server-cluster::_chef-ha'
#   recipe 'lvm'
#   recipe 'qa-chef-server-cluster::_backend'
#   attribute 'ha-config', ha_config
#   files(
#     '/etc/opscode/webui_priv.pem' => '/tmp/stash/webui_priv.pem',
#     '/etc/opscode/webui_pub.pem' => '/tmp/stash/webui_pub.pem',
#     '/etc/opscode/pivotal.pem' => '/tmp/stash/pivotal.pem',
#     '/etc/opscode/private-chef-secrets.json' => '/tmp/stash/private-chef-secrets.json'
#   )
# end
#
# # converge frontend server with all the bits!
# machine 'frontend' do
#   recipe 'qa-chef-server-cluster::_frontend'
#   attribute 'ha-config', ha_config
#   files(
#     '/etc/opscode/webui_priv.pem' => '/tmp/stash/webui_priv.pem',
#     '/etc/opscode/webui_pub.pem' => '/tmp/stash/webui_pub.pem',
#     '/etc/opscode/pivotal.pem' => '/tmp/stash/pivotal.pem',
#     '/etc/opscode/private-chef-secrets.json' => '/tmp/stash/private-chef-secrets.json'
#   )
# end
