#
# Cookbook Name:: build
# Recipe:: provision_ha_stage_db
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#

# path = node['delivery']['workspace']['repo']
# qa_path = "#{path}/deps/qa-chef-server-cluster"
#
#     node.run_state['delivery']['stage']['data']['ha'][identifier]['ebs-volume'] = JSON.parse(File.read('data_bags/aws_ebs_volume/default-ha.json'))
#
#     if File.exist?('data_bags/aws_network_interface/default-ha.json')
#       node.run_state['delivery']['stage']['data']['ha'][identifier]['network-interface'] = JSON.parse(File.read('data_bags/aws_network_interface/default-ha.json'))
#     end
#   end
# end

store_machine_data(node['chef-server-acceptance']['identifier'], ['ha-frontend', 'ha-bootstrap-backend', 'ha-secondary-backend'])
store_data_bag(node['chef-server-acceptance']['identifier'], 'aws_ebs_volume', 'ha')
store_data_bag(node['chef-server-acceptance']['identifier'], 'aws_network_interface', 'ha')

delivery_stage_db
