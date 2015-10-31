#
# Cookbook Name:: build
# Recipe:: provision_tier_stage_db
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#

store_machine_data(node['chef-server-acceptance']['identifier'], ['tier-frontend', 'tier-bootstrap-backend'])

delivery_stage_db
