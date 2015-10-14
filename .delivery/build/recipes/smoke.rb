#
# Cookbook Name:: build
# Recipe:: smoke
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# we are ignoring the URD for now
return unless node['delivery']['change']['stage'] == 'acceptance'

include_recipe 'delivery-red-pill::smoke'
