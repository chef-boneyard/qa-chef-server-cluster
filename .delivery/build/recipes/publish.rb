#
# Cookbook Name:: build
# Recipe:: publish
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe "delivery-truck::publish" if node['delivery']['change']['pipeline'] == 'master'
