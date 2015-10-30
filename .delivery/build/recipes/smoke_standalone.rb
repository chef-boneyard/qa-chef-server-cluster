#
# Cookbook Name:: build
# Recipe:: smoke_standalone
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# ruby_block 'run-pedant-smoke' do
#   block do
#     run_chef_client('standalone-server-test')
#   end
# end

run_chef_client('standalone-server-test')
