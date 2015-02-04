#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: ha-cluster
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

include_recipe 'qa-chef-server-cluster::_cluster-setup'

node.default['qa-chef-server-cluster']['chef-server-config']['topology'] = 'ha'

machine_batch do
  machines 'bootstrap-backend'#, 'secondary-backend'
end

require 'chef/provisioning/fog_driver/providers/aws'

aws_creds = Chef::Provisioning::FogDriver::Providers::AWS.get_aws_credentials

aws_ebs_volume 'bootstrap-backend' do
  aws_access_key aws_creds[:aws_access_key_id]
  aws_secret_access_key aws_creds[:aws_secret_access_key]
  size 10
  device '/dev/sdd'
  volume_type 'io1'
  piops 300
  action [ :create, :attach ]
end

# machine 'bootstrap-backend' do
#   recipe 'qa-chef-server-cluster::_chef-ha'
#   recipe 'qa-chef-server-cluster::_backend'
#   attribute 'qa-chef-server-cluster', node['qa-chef-server-cluster']
#   attribute %w[ chef-server-cluster bootstrap enable ], true
#   action :converge
# end

# %w{ actions-source.json webui_priv.pem }.each do |analytics_file|

#   machine_file "/etc/opscode-analytics/#{analytics_file}" do
#     local_path "/tmp/stash/#{analytics_file}"
#     machine 'bootstrap-backend'
#     action :download
#   end

# end

# %w{ pivotal.pem webui_pub.pem private-chef-secrets.json }.each do |opscode_file|

#   machine_file "/etc/opscode/#{opscode_file}" do
#     local_path "/tmp/stash/#{opscode_file}"
#     machine 'bootstrap-backend'
#     action :download
#   end

# end

# machine 'secondary-backend' do
#   recipe 'qa-chef-server-cluster::_chef-ha'
#   recipe 'qa-chef-server-cluster::_backend'
#   attribute 'qa-chef-server-cluster', node['qa-chef-server-cluster']
#   attribute %w[ chef-server-cluster bootstrap enable ], false
#   action :converge
#     files(
#         '/etc/opscode/webui_priv.pem' => '/tmp/stash/webui_priv.pem',
#         '/etc/opscode/webui_pub.pem' => '/tmp/stash/webui_pub.pem',
#         '/etc/opscode/pivotal.pem' => '/tmp/stash/pivotal.pem',
#         '/etc/opscode/private-chef-secrets.json' => '/tmp/stash/private-chef-secrets.json'
#        )
# end



# machine 'frontend' do
#   recipe 'qa-chef-server-cluster::_frontend'
#   attribute 'qa-chef-server-cluster', node['qa-chef-server-cluster']
#   action :converge
#   files(
#         '/etc/opscode/webui_priv.pem' => '/tmp/stash/webui_priv.pem',
#         '/etc/opscode/webui_pub.pem' => '/tmp/stash/webui_pub.pem',
#         '/etc/opscode/pivotal.pem' => '/tmp/stash/pivotal.pem',
#         '/etc/opscode/private-chef-secrets.json' => '/tmp/stash/private-chef-secrets.json'
#        )
# end
