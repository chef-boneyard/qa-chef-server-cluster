#
# Cookbook Name:: build
# Recipe:: functional_general_prep
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'build::prepare_deps'
include_recipe 'build::prepare_acceptance'

repo = node['delivery']['workspace']['repo']

cookbook_file File.join(repo, 'functional.json') do
  source 'functional.json'
end

directory File.join(repo, '.chef', 'nodes') do
  action :create
end
