#
# Cookbook Name:: build
# Recipe:: functional_standalone
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

repo = node['delivery']['workspace']['repo']
attributes_functional_file = File.join(repo, 'functional.json')

ruby_block 'run-pedant' do
  block do
    run_chef_client('standalone-server-test', attributes_file: attributes_functional_file)
  end
end

ruby_block 'destroy-machine' do
  block do
    run_chef_client('standalone-server-destroy')
  end
end
