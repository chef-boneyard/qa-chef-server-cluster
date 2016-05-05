#
# Cookbook Name:: build
# Recipe:: provision_ha_generate_test_data
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

run_chef_client('ha-cluster-generate-test-data', attributes_file: attributes_install_file)
