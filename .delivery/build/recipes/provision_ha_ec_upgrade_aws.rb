#
# Cookbook Name:: build
# Recipe:: provision_tier_ec_upgrade_aws
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node.override['chef-server-acceptance']['identifier'] = 'ha-ec-upgrade'
node.override['chef-server-acceptance']['upgrade'] = true
node.override['chef_server_upgrade_from_flavor'] = 'enterprise_chef'
node.override['chef_server_upgrade_from_version'] = '11.3.2'
node.override['chef_server_upgrade_from_channel'] = 'stable'
node.override['chef_server_instance_size'] = 'm3.large'

include_recipe 'build::provision_general_prep'

run_chef_client('ha-enterprise-chef-cluster', attributes_file: attributes_install_file)

# must use non-default EC ha recipe, so we cannot use provision_ha_generate_test_data_and_upgrade
include_recipe 'build::provision_ha_generate_test_data'

run_chef_client('ha-enterprise-chef-cluster-upgrade', attributes_file: attributes_upgrade_file)

include_recipe 'build::provision_ha_stage_db'
