#
# Cookbook Name:: build
# Recipe:: functional_standalone
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

path = node['delivery']['workspace']['repo']
cache = node['delivery']['workspace']['cache']

attributes_functional_file = File.join(cache, 'functional.json')
repo_config_file = File.join(path, '.chef/knife.rb')

ruby_block 'run-pedant' do
  block do
    shell_out("bundle exec chef-client -z -p 10257 -j #{attributes_functional_file} -c #{repo_config_file} -o qa-chef-server-cluster::standalone-server-test --force-formatter", path)
  end
end

ruby_block 'destroy-machine' do
  block do
    shell_out("bundle exec chef-client -z -p 10257 -c #{repo_config_file} -o qa-chef-server-cluster::standalone-server-destroy --force-formatter", path)
  end
  action :run
end
