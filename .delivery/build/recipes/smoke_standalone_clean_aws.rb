#
# Cookbook Name:: build
# Recipe:: smoke_standalone_clean_aws
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node.override['chef-server-acceptance']['identifier'] = 'standalone-clean'

include_recipe 'build::smoke_general_prep'

include_recipe 'build::standalone_prepare_machine_configs'

include_recipe 'build::smoke_standalone'
