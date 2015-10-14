#
# Cookbook Name:: build
# Recipe:: smoke_tier_ec_upgrade_aws
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node.override['chef-server-acceptance']['identifier'] = 'tier-ec-upgrade'

include_recipe 'build::smoke_general_prep'

include_recipe 'build::tier_prepare_machine_configs'

include_recipe 'build::smoke_tier'
