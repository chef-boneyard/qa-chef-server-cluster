#
# Cookbook Name:: build
# Recipe:: provision_standalone
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

ruby_block 'stand-up-machine' do
  block do
    shell_out_retry("bundle exec chef-client -z -p 10257 -j install.json -o qa-chef-server-cluster::standalone-server --force-formatter")
  end
end
