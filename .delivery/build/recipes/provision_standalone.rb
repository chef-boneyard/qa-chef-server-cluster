#
# Cookbook Name:: build
# Recipe:: provision_standalone
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

path = node['delivery']['workspace']['repo']
cache = node['delivery']['workspace']['cache']
qa_path = "#{path}/deps/qa-chef-server-cluster"
attributes_install_file = File.join(cache, 'install.json')
repo_knife_file = File.join(qa_path, '.chef/knife.rb')
repo_config_file = File.join(path, '.chef/config.rb')

# ruby_block 'stand-up-machine' do
#   block do
#     Dir.chdir qa_path
#     shell_out_retry("bundle exec chef-client -z -p 10257 -j #{attributes_install_file} -c #{repo_knife_file} -o qa-chef-server-cluster::standalone-server --force-formatter")
#   end
# end

include_recipe 'qa-chef-server-cluster::standalone-server'
