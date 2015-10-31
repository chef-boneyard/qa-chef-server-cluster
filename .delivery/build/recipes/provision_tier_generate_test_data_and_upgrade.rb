#
# Cookbook Name:: build
# Recipe:: provision_tier_generate_test_data
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

repo = node['delivery']['workspace']['repo']

attributes_install_file = File.join(repo, 'install.json')
attributes_upgrade_file = File.join(repo, 'upgrade.json')

run_chef_client('tier-cluster-generate-test-data', attributes_file: attributes_install_file)
run_chef_client('tier-cluster-upgrade', attributes_file: attributes_upgrade_file)
