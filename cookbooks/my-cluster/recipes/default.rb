#
# Cookbook Name:: my-cluster
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

Chef::Log.info "metal-provisioner-key-name: #{node['chef-server-cluster']['metal-provisioner-key-name']}"
