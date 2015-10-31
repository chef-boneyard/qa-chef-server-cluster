#
# Cookbook Name:: build
# Recipe:: provision_ha_generate_test_data_and_upgrade
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

repo = node['delivery']['workspace']['repo']
attributes_install_file = File.join(repo, 'install.json')
attributes_upgrade_file = File.join(repo, 'upgrade.json')

include_recipe 'build::provision_ha_generate_test_data'

run_chef_client('ha-cluster-upgrade', attributes_file: attributes_upgrade_file)
