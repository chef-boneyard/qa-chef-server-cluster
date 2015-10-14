#
# Cookbook Name:: build
# Recipe:: provision_ha_clean_aws
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node.override['chef-server-acceptance']['identifier'] = 'ha-clean'
node.override['chef-server-acceptance']['upgrade'] = false

include_recipe 'build::provision_general_prep'

include_recipe 'build::provision_ha'

include_recipe 'build::provision_ha_stage_db'
