#
# Cookbook Name:: build
# Recipe:: standalone_prepare_machine_configs
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

delivery_stage_db do
  action :download
end

ruby_block 'write-machine-configs' do
  block do
    nodes_dir = File.join(node['delivery']['workspace']['repo'], '.chef', 'nodes')
    identifier = node['chef-server-acceptance']['identifier']

    standalone_state = ::Chef.node.run_state['delivery']['stage']['data'][identifier]['standalone']
    IO.write(File.join(nodes_dir, 'default-standalone.json'), standalone_state.to_json)
  end
end
