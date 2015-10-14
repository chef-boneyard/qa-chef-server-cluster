#
# Cookbook Name:: build
# Recipe:: smoke_standalone_osc_upgrade_aws
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node.override['chef-server-acceptance']['identifier'] = 'standalone-osc-upgrade'

include_recipe 'build::smoke_general_prep'

include_recipe 'build::standalone_prepare_machine_configs'

include_recipe 'build::smoke_standalone'
