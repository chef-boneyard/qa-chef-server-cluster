#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: ha-enterprise-chef-backend
#
# Author: Joshua Timberman <joshua@getchef.com>
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

include_recipe 'qa-chef-server-cluster::node-setup'

chef_package current_server.package_name do
  package_url node['qa-chef-server-cluster']['chef-server']['url']
  install_method node['qa-chef-server-cluster']['chef-server']['install_method']
  version node['qa-chef-server-cluster']['chef-server']['version']
  integration_builds node['qa-chef-server-cluster']['chef-server']['integration_builds']
  repository node['qa-chef-server-cluster']['chef-server']['repo']
  config node['qa-chef-server-cluster']['chef-server-config']
end

file ::File.join(current_server.config_path, 'pivotal.pem') do
  mode 00644
  # without this guard, we create an empty file, causing bootstrap to
  # not actually work, as it checks the presence of this file.
  only_if { ::File.exist?(::File.join(current_server.config_path, 'pivotal.pem')) }
end

[
  'wget http://oss.linbit.com/drbd/8.4/drbd-8.4.3.tar.gz',
  'tar xfvz drbd-8.4.3.tar.gz'
].each do |cmd|
  execute cmd
end

[
  './configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc --with-km',
  'make KDIR=/lib/modules/`uname -r`/build',
  'make install'
].each do |cmd|
  execute cmd do
    cwd 'drbd-8.4.3'
  end
end

execute 'modprobe drbd'

ruby_block 'reconfigure and kill' do
  block do
    begin
      ctl = Mixlib::ShellOut.new('private-chef-ctl reconfigure', live_stream: STDOUT, timeout: 60)
      ctl.run_command
    rescue Mixlib::ShellOut::CommandTimeout => exception
      raise exception unless ctl.stdout.include?('Press CTRL-C to abort')
    end
  end
  not_if { ::File.exist?('/var/opt/opscode/drbd/drbd_ready') }
end

# Ubuntu 12.04 step not included in docs
# "on" nodes must match `hostname` value, so we strip the domain
execute 'remove domain from pc0.res' do
  command 'sed -i s/.us-west-2.compute.internal/\/ /var/opt/opscode/drbd/etc/pc0.res'
  only_if 'grep ".us-west-2.compute.internal" /var/opt/opscode/drbd/etc/pc0.res'
end

# Ubuntu 12.04 step not included in docs
execute 'drbdadm create-md pc0' do
  only_if 'drbdadm dump-md pc0 2>&1 | grep "No valid meta data"'
end

execute 'drbdadm up pc0' do
  not_if 'drbdadm dump-md pc0 2>&1 | grep "Device \'0\' is configured!"'
end

service 'drbd' do
  action :start
end
