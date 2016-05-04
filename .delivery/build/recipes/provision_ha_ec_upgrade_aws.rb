#
# Cookbook Name:: build
# Recipe:: provision_tier_ec_upgrade_aws
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node.override['chef-server-acceptance']['identifier'] = 'ha-ec-upgrade'
node.override['chef-server-acceptance']['upgrade'] = true
node.override['chef_server_flavor'] = 'enterprise_chef'

include_recipe 'build::provision_general_prep'

repo = node['delivery']['workspace']['repo']
attributes_install_file = File.join(repo, 'install.json')
attributes_upgrade_file = File.join(repo, 'upgrade.json')

template attributes_install_file do
  source 'attributes.json.erb'
  action :create
  variables instance_type: 'm3.large'
end

run_chef_client('ha-enterprise-chef-cluster', attributes_file: attributes_install_file)

# must use non-default EC ha recipe, so we cannot use provision_ha_generate_test_data_and_upgrade
include_recipe 'build::provision_ha_generate_test_data'

run_chef_client('ha-enterprise-chef-cluster-upgrade', attributes_file: attributes_upgrade_file)

include_recipe 'build::provision_ha_stage_db'
