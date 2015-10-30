#
# Cookbook Name:: build
# Recipe:: provision_standalone_stage_db
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#

store_machine_data(node['chef-server-acceptance']['identifier'], ['standalone'])

delivery_stage_db
