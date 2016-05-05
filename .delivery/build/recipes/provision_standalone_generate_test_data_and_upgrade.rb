#
# Cookbook Name:: build
# Recipe:: provision_standalone_generate_test_data
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

run_chef_client('standalone-server-generate-test-data', attributes_file: attributes_install_file)
run_chef_client('standalone-server-upgrade', attributes_file: attributes_upgrade_file)
