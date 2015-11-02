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
