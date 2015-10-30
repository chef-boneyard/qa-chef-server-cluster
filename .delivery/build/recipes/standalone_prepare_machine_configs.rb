#
# Cookbook Name:: build
# Recipe:: standalone_prepare_machine_configs
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

delivery_stage_db do
  action :download
end

write_machine_data(node['chef-server-acceptance']['identifier'], ['standalone'])
