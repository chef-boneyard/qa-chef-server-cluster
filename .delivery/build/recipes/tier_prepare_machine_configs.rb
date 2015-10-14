#
# Cookbook Name:: build
# Recipe:: tier_prepare_machine_configs
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

delivery_stage_db do
  action :download
end

path = node['delivery']['workspace']['repo']
qa_path = "#{path}/deps/qa-chef-server-cluster"

ruby_block 'write-machine-configs' do
  block do
    Dir.chdir qa_path

    identifier = node['chef-server-acceptance']['identifier']
    
    frontend_state = ::Chef.node.run_state['delivery']['stage']['data']['tiered'][identifier]['frontend']
    IO.write('nodes/default-tier-frontend.json', frontend_state.to_json)

    backend_state = ::Chef.node.run_state['delivery']['stage']['data']['tiered'][identifier]['bootstrap-backend']
    IO.write('nodes/default-tier-bootstrap-backend.json', backend_state.to_json)
  end
end
