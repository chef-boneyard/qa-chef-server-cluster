#
# Cookbook Name:: build
# Recipe:: provision_standalone_stage_db
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#
# store all of the machine info in a data bag we can pass to the smoke and functional stages

store_machine_data(node['chef-server-acceptance']['identifier'], ['standalone'])

# ruby_block 'store machine info' do
#   block do
#     nodes_dir = File.join(node['delivery']['workspace']['repo'], '.chef', 'nodes')
#     identifier = node['chef-server-acceptance']['identifier']
#
#     # load the json that represents this machine
#     node.run_state['delivery'] ||= {}
#     node.run_state['delivery']['stage'] ||= {}
#     node.run_state['delivery']['stage']['data'] ||= {}
#     node.run_state['delivery']['stage']['data'][identifier] ||= {}
#     node.run_state['delivery']['stage']['data'][identifier]['standalone'] = JSON.parse(
#       File.read(
#         File.join(nodes_dir, 'default-standalone.json')
#       )
#     )
#   end
# end

delivery_stage_db
