#
# Cookbook Name:: build
# Recipe:: provision_tier_generate_test_data
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

path = node['delivery']['workspace']['repo']
cache = node['delivery']['workspace']['cache']
qa_path = "#{path}/deps/qa-chef-server-cluster"
attributes_install_file = File.join(cache, 'install.json')
attributes_upgrade_file = File.join(cache, 'upgrade.json')
repo_knife_file = File.join(qa_path, '.chef/knife.rb')

ruby_block 'generate-test-data' do
  block do
    Dir.chdir qa_path
    shell_out_retry("bundle exec chef-client -z -p 10257 -j #{attributes_install_file} -c #{repo_knife_file} -o qa-chef-server-cluster::tier-cluster-generate-test-data --force-formatter")
  end
end

ruby_block 'upgrade-machine' do
  block do
    Dir.chdir qa_path
    shell_out_retry("bundle exec chef-client -z -p 10257 -j #{attributes_upgrade_file} -c #{repo_knife_file} -o qa-chef-server-cluster::tier-cluster-upgrade --force-formatter")
  end
end
