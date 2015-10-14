#
# Cookbook Name:: build
# Recipe:: provision_standalone_clean_aws
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node.override['chef-server-acceptance']['identifier'] = 'standalone-clean'
node.override['chef-server-acceptance']['upgrade'] = false

include_recipe 'build::provision_general_prep'

include_recipe 'build::provision_standalone'

include_recipe 'build::provision_standalone_stage_db'
