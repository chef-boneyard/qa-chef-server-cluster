#
# Cookbook Name:: my-cluster
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

Chef::Log.info "metal-provisioner-key-name: #{node.default['chef-server-cluster']['aws']['machine_options']['bootstrap_options']['key_name']}"
