#
# Cookbook Name:: build
# Recipe:: provision_standalone
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

install_file = File.join(node['delivery']['workspace']['repo'], 'install.json')

run_chef_client('standalone-server', attributes_file: install_file)

# ruby_block 'stand-up-machine' do
#   block do
#     run_chef_client('standalone-server', attributes_file: install_file)
#   end
# end
