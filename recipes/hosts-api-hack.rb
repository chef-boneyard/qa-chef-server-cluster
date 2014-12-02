chef_server_config = data_bag_item('chef_server', 'topology').to_hash

template '/etc/hosts' do
  source 'hosts.erb'
  variables :chef_server_config => node['chef-server-cluster']
end
