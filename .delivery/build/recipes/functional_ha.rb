#
# Cookbook Name:: build
# Recipe:: functional_tier
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

path = node['delivery']['workspace']['repo']
cache = node['delivery']['workspace']['cache']
qa_path = "#{path}/deps/qa-chef-server-cluster"
attributes_functional_file = File.join(cache, 'functional.json')
repo_knife_file = File.join(qa_path, '.chef/knife.rb')

ruby_block 'run-pedant' do
  block do
    Dir.chdir qa_path
    shell_out!("bundle exec chef-client -z -p 10257 -j #{attributes_functional_file} -c #{repo_knife_file} -o qa-chef-server-cluster::ha-cluster-test --force-formatter", live_stream: STDOUT, timeout: 7200)
  end
end

ruby_block 'destroy-machine' do
  block do
    shell_out!("bundle exec chef-client -z -p 10257 -c #{repo_knife_file} -o qa-chef-server-cluster::ha-cluster-destroy --force-formatter", live_stream: STDOUT, timeout: 7200)
  end
  action :run
end
