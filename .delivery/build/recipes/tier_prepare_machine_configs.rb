#
# Cookbook Name:: build
# Recipe:: tier_prepare_machine_configs
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

delivery_stage_db do
  action :download
end

write_machine_data(node['chef-server-acceptance']['identifier'], ['tier-frontend', 'tier-bootstrap-backend'])
