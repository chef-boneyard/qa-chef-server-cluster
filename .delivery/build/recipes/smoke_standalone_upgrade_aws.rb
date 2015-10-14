#
# Cookbook Name:: build
# Recipe:: smoke_standalone_upgrade_aws
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# rubocop:disable LineLength

node.override['chef-server-acceptance']['identifier'] = 'standalone-upgrade'

include_recipe 'build::smoke_general_prep'

include_recipe 'build::standalone_prepare_machine_configs'

include_recipe 'build::smoke_standalone'
