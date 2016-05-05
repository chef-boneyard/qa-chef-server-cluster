#
# Cookbook Name:: build
# Recipe:: provision_ha_upgrade_aws
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node.override['chef-server-acceptance']['identifier'] = 'ha-upgrade'
node.override['chef-server-acceptance']['upgrade'] = true
node.override['chef_server_upgrade_from_version'] = 'latest'
node.override['chef_server_upgrade_from_channel'] = 'stable'
node.override['chef_server_upgrade_from_flavor'] = 'chef_server'

include_recipe 'build::provision_general_prep'

include_recipe 'build::provision_ha'

include_recipe 'build::provision_ha_generate_test_data_and_upgrade'

include_recipe 'build::provision_ha_stage_db'
