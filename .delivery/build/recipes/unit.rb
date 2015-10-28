#
# Cookbook Name:: build
# Recipe:: unit
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

gem_package 'mixlib-versioning'

include_recipe 'delivery-truck::unit'
