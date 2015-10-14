#
# Cookbook Name:: build
# Recipe:: functional_general_prep
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'build::prepare_deps'
include_recipe 'build::prepare_acceptance'

path = node['delivery']['workspace']['repo']
cache = node['delivery']['workspace']['cache']
qa_path = "#{path}/deps/qa-chef-server-cluster"
attributes_functional_file = File.join(cache, 'functional.json')

cookbook_file attributes_functional_file do
  source 'functional.json'
end

directory File.join(qa_path, 'nodes') do
  action :create
end
