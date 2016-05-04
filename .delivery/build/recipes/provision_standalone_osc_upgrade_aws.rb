#
# Cookbook Name:: build
# Recipe:: provision_standalone_osc_upgrade_aws
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node.override['chef-server-acceptance']['identifier'] = 'standalone-osc-upgrade'
node.override['chef-server-acceptance']['upgrade'] = true
node.override['chef_server_flavor'] = 'open_source_chef'

include_recipe 'build::provision_general_prep'

attributes_install_file = File.join(node['delivery']['workspace']['repo'], 'install.json')
template attributes_install_file do
  source 'attributes.json.erb'
  action :create
  variables chef_version: '11.1.7',
end

include_recipe 'build::provision_standalone'

include_recipe 'build::provision_standalone_generate_test_data_and_upgrade'

include_recipe 'build::provision_standalone_stage_db'
