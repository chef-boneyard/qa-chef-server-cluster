#
# Cookbook Name:: build
# Recipe:: provision_standalone
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

path = node['delivery']['workspace']['repo']
repo_config_file = File.join(path, '.chef/config.rb')

ruby_block 'stand-up-machine' do
  block do
    shell_out("bundle exec chef-client -z -p 10257 -j install.json -c #{repo_config_file} -o qa-chef-server-cluster::standalone-server --force-formatter", path)
  end
end
