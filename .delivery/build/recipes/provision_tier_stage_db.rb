#
# Cookbook Name:: build
# Recipe:: provision_tier_stage_db
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#

# path = node['delivery']['workspace']['repo']
# qa_path = "#{path}/deps/qa-chef-server-cluster"
#
# ruby_block 'store machine info' do
#   block do
#     Dir.chdir qa_path
#
#     identifier = node['chef-server-acceptance']['identifier']
#
#     # load the json that represents this machine
#     node.run_state['delivery'] ||= {}
#     node.run_state['delivery']['stage'] ||= {}
#     node.run_state['delivery']['stage']['data'] ||= {}
#     node.run_state['delivery']['stage']['data']['tiered'] ||= {}
#     node.run_state['delivery']['stage']['data']['tiered'][identifier] ||= {}
#
#     node.run_state['delivery']['stage']['data']['tiered'][identifier]['frontend'] = JSON.parse(File.read('nodes/default-tier-frontend.json'))
#     node.run_state['delivery']['stage']['data']['tiered'][identifier]['bootstrap-backend'] = JSON.parse(File.read('nodes/default-tier-bootstrap-backend.json'))
#   end
# end

store_machine_data(node['chef-server-acceptance']['identifier'], ['frontend', 'bootstrap-backend'])

delivery_stage_db
