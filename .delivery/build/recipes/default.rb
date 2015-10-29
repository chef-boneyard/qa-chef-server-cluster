#
# Cookbook Name:: build
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.


# get to the qa-chef-server-cluster project root and use it as a cache
# as it is persistent between build jobs
gem_cache = File.join(node['delivery']['workspace']['root'], "../../../project_gem_cache")

directory gem_cache do
  # set the owner to the dbuild so that the other recipes can write to here
  owner node['delivery_builder']['build_user']
  mode "0755"
  recursive true
  action :create
end

include_recipe 'delivery-sugar-extras::default'
include_recipe 'delivery-red-pill::default'
include_recipe 'delivery-truck::default'
include_recipe 'build-essential'
