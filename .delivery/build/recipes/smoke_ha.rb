#
# Cookbook Name:: build
# Recipe:: smoke_ha
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

path = node['delivery']['workspace']['repo']
qa_path = "#{path}/deps/qa-chef-server-cluster"

repo_knife_file = File.join(qa_path, '.chef/knife.rb')

ruby_block 'run-pedant-smoke' do
  block do
    Dir.chdir qa_path
    shell_out_retry("bundle exec chef-client -z -p 10257 -c #{repo_knife_file} -o qa-chef-server-cluster::ha-cluster-test --force-formatter")
  end
end
