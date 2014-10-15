#
# Cookbook Name:: my-cluster
# Recipe:: provision
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

include_recipe 'my-cluster::default'

include_recipe 'chef-server-cluster::metal-provision'
