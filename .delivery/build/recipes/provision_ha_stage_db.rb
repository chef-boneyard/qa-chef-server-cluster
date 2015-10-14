#
# Cookbook Name:: build
# Recipe:: provision_ha_stage_db
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#

path = node['delivery']['workspace']['repo']
qa_path = "#{path}/deps/qa-chef-server-cluster"

ruby_block 'store machine info' do
  block do
    Dir.chdir qa_path

    identifier = node['chef-server-acceptance']['identifier']

    # load the json that represents this machine
    node.run_state['delivery'] ||= {}
    node.run_state['delivery']['stage'] ||= {}
    node.run_state['delivery']['stage']['data'] ||= {}
    node.run_state['delivery']['stage']['data']['ha'] ||= {}
    node.run_state['delivery']['stage']['data']['ha'][identifier] ||= {}
    node.run_state['delivery']['stage']['data']['ha'][identifier]['frontend'] = JSON.parse(File.read('nodes/default-ha-frontend.json'))
    node.run_state['delivery']['stage']['data']['ha'][identifier]['bootstrap-backend'] = JSON.parse(File.read('nodes/default-ha-bootstrap-backend.json'))
    node.run_state['delivery']['stage']['data']['ha'][identifier]['secondary-backend'] = JSON.parse(File.read('nodes/default-ha-secondary-backend.json'))

    Chef::Log.fatal("EBS VOLUME DATA BAG")
    Chef::Log.fatal(JSON.parse(File.read('data_bags/aws_ebs_volume/default-ha.json')))
    node.run_state['delivery']['stage']['data']['ha'][identifier]['ebs-volume'] = JSON.parse(File.read('data_bags/aws_ebs_volume/default-ha.json'))
    Chef::Log.fatal(node.run_state['delivery']['stage']['data']['ha'][identifier]['ebs-volume'])

    if File.exist?('data_bags/aws_network_interface/default-ha.json')
      node.run_state['delivery']['stage']['data']['ha'][identifier]['network-interface'] = JSON.parse(File.read('data_bags/aws_network_interface/default-ha.json'))
    end
  end
end

delivery_stage_db
