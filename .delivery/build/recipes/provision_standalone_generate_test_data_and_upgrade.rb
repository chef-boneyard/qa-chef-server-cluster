#
# Cookbook Name:: build
# Recipe:: provision_standalone_generate_test_data
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

repo = node['delivery']['workspace']['repo']

attributes_install_file = File.join(repo, 'install.json')
attributes_upgrade_file = File.join(repo, 'upgrade.json')

run_chef_client('standalone-server-generate-test-data', attributes_install_file)
run_chef_client('standalone-server-upgrade', attributes_upgrade_file)
