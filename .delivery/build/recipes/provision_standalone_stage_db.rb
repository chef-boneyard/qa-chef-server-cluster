#
# Cookbook Name:: build
# Recipe:: provision_standalone_stage_db
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#
# store all of the machine info in a data bag we can pass to the smoke and functional stages

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
    node.run_state['delivery']['stage']['data'][identifier] ||= {}
    node.run_state['delivery']['stage']['data'][identifier]['standalone'] = JSON.parse(File.read('nodes/default-standalone.json'))
  end
end


delivery_stage_db
