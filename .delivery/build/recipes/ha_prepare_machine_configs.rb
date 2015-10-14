#
# Cookbook Name:: build
# Recipe:: ha_prepare_machine_configs
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

delivery_stage_db do
  action :download
end

path = node['delivery']['workspace']['repo']
cache = node['delivery']['workspace']['cache']
qa_path = "#{path}/deps/qa-chef-server-cluster"

attributes_functional_file = File.join(cache, 'functional.json')
cookbook_file attributes_functional_file do
  source 'functional.json'
end

%w( nodes data_bags/aws_ebs_volume data_bags/aws_network_interface ).each do |dir|
  directory File.join(qa_path, dir) do
    action :create
    recursive true
  end
end

ruby_block 'write-machine-configs' do
  block do
    Dir.chdir qa_path

    identifier = node['chef-server-acceptance']['identifier']

    # nodes
    frontend_state = ::Chef.node.run_state['delivery']['stage']['data']['ha'][identifier]['frontend']
    IO.write('nodes/default-ha-frontend.json', frontend_state.to_json)

    bootstrap_backend_state = ::Chef.node.run_state['delivery']['stage']['data']['ha'][identifier]['bootstrap-backend']
    IO.write('nodes/default-ha-bootstrap-backend.json', bootstrap_backend_state.to_json)

    secondary_backend_state = ::Chef.node.run_state['delivery']['stage']['data']['ha'][identifier]['secondary-backend']
    IO.write('nodes/default-ha-secondary-backend.json', secondary_backend_state.to_json)

    # data bags
    Chef::Log.fatal("EBS VOLUME DATA BAG")
    Chef::Log.fatal(::Chef.node.run_state['delivery']['stage']['data']['ha'][identifier]['ebs-volume'])
    aws_ebs_volume_state = ::Chef.node.run_state['delivery']['stage']['data']['ha'][identifier]['ebs-volume']
    IO.write('data_bags/aws_ebs_volume/default-ha.json', aws_ebs_volume_state.to_json)
    Chef::Log.fatal(aws_ebs_volume_state.to_json)

    unless ::Chef.node.run_state['delivery']['stage']['data']['ha']['network-interface'].nil?
      aws_network_interface_state = ::Chef.node.run_state['delivery']['stage']['data']['ha'][identifier]['network-interface']
      IO.write('data_bags/aws_network_interface/default-ha.json', aws_network_interface_state.to_json)
    end
  end
end
