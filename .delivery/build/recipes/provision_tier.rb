#
# Cookbook Name:: build
# Recipe:: provision_tier
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

attributes_install_file = File.join(node['delivery']['workspace']['repo'], 'install.json')
run_chef_client('tier-cluster', attributes_file: attributes_install_file)
