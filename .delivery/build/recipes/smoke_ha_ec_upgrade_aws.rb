#
# Cookbook Name:: build
# Recipe:: smoke_ha_ec_upgrade_aws
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node.override['chef-server-acceptance']['identifier'] = 'ha-ec-upgrade'

include_recipe 'build::smoke_general_prep'

include_recipe 'build::ha_prepare_machine_configs'

include_recipe 'build::smoke_ha'
