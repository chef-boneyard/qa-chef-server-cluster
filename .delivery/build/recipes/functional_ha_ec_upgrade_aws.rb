#
# Cookbook Name:: build
# Recipe:: functional_ha_ec_upgrade_aws
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node.override['chef-server-acceptance']['identifier'] = 'ha-ec-upgrade'

include_recipe 'build::functional_general_prep'

include_recipe 'build::ha_prepare_machine_configs'

run_chef_client('ha-enterprise-chef-cluster-test')
