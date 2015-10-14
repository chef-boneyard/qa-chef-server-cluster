#
# Cookbook Name:: build
# Recipe:: provision_tier_clean_aws
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node.override['chef-server-acceptance']['identifier'] = 'tier-clean'
node.override['chef-server-acceptance']['upgrade'] = false

include_recipe 'build::provision_general_prep'

include_recipe 'build::provision_tier'

include_recipe 'build::provision_tier_stage_db'
