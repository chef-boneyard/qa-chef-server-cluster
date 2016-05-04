#
# Cookbook Name:: build
# Recipe:: provision_tier_ec_upgrade_aws
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node.override['chef-server-acceptance']['identifier'] = 'tier-ec-upgrade'
node.override['chef-server-acceptance']['upgrade'] = true
node.override['chef_server_flavor'] = 'enterprise_chef'

include_recipe 'build::provision_general_prep'

attributes_install_file = File.join(node['delivery']['workspace']['repo'], 'install.json')
template attributes_install_file do
  source 'attributes.json.erb'
  action :create
  variables chef_version: '11.3.2',
end

include_recipe 'build::provision_tier'

include_recipe 'build::provision_tier_generate_test_data_and_upgrade'

include_recipe 'build::provision_tier_stage_db'
