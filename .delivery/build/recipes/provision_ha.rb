#
# Cookbook Name:: build
# Recipe:: provision_ha
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

attributes_install_file = File.join(node['delivery']['workspace']['repo'], 'install.json')

run_chef_client('ha-cluster', attributes_file: attributes_install_file)
