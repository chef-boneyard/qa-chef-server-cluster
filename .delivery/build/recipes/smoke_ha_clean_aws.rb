#
# Cookbook Name:: build
# Recipe:: smoke_ha_clean_aws
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node.override['chef-server-acceptance']['identifier'] = 'ha-clean'

include_recipe 'build::smoke_general_prep'

include_recipe 'build::ha_prepare_machine_configs'

include_recipe 'build::smoke_ha'
