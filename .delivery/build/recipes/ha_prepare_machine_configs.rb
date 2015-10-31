#
# Cookbook Name:: build
# Recipe:: ha_prepare_machine_configs
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

delivery_stage_db do
  action :download
end

repo = node['delivery']['workspace']['repo']

attributes_functional_file = File.join(repo, 'functional.json')
cookbook_file attributes_functional_file do
  source 'functional.json'
end

%w( nodes data_bags/aws_ebs_volume data_bags/aws_network_interface ).each do |dir|
  directory File.join(repo, dir) do
    action :create
    recursive true
  end
end

write_machine_data(node['chef-server-acceptance']['identifier'],
                   ['ha-frontend', 'ha-bootstrap-backend', 'ha-secondary-backend'])
write_data_bag(node['chef-server-acceptance']['identifier'], 'aws_ebs_volume', 'ha')
write_data_bag(node['chef-server-acceptance']['identifier'], 'aws_network_interface', 'ha')

# # data bags
# Chef::Log.fatal("EBS VOLUME DATA BAG")
# Chef::Log.fatal(::Chef.node.run_state['delivery']['stage']['data']['ha'][identifier]['ebs-volume'])
# aws_ebs_volume_state = ::Chef.node.run_state['delivery']['stage']['data']['ha'][identifier]['ebs-volume']
# IO.write('data_bags/aws_ebs_volume/default-ha.json', aws_ebs_volume_state.to_json)
# Chef::Log.fatal(aws_ebs_volume_state.to_json)
#
# unless ::Chef.node.run_state['delivery']['stage']['data']['ha']['network-interface'].nil?
#   aws_network_interface_state = ::Chef.node.run_state['delivery']['stage']['data']['ha'][identifier]['network-interface']
#   IO.write('data_bags/aws_network_interface/default-ha.json', aws_network_interface_state.to_json)
# end
