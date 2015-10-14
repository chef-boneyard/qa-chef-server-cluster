#
# Cookbook Name:: build
# Recipe:: smoke_tier_clean_aws
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node.override['chef-server-acceptance']['identifier'] = 'tier-clean'

include_recipe 'build::smoke_general_prep'

include_recipe 'build::tier_prepare_machine_configs'

include_recipe 'build::smoke_tier'
