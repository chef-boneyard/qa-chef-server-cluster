#
# Cookbook Name:: build
# Recipe:: provision_ha_stage_db
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#

store_machine_data(node['chef-server-acceptance']['identifier'], ['ha-frontend', 'ha-bootstrap-backend', 'ha-secondary-backend'])
store_data_bag(node['chef-server-acceptance']['identifier'], 'aws_ebs_volume', 'ha')
store_data_bag(node['chef-server-acceptance']['identifier'], 'aws_network_interface', 'ha')

delivery_stage_db
