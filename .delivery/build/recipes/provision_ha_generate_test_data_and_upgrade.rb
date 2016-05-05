#
# Cookbook Name:: build
# Recipe:: provision_ha_generate_test_data_and_upgrade
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'build::provision_ha_generate_test_data'

run_chef_client('ha-cluster-upgrade', attributes_file: attributes_upgrade_file)
