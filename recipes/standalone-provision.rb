directory '/etc/opscode' do
  mode 0755
  recursive true
end

chef_server_package = data_bag_item('chef_server', 'package').to_hash

chef_server_ingredient 'chef-server-core' do
  version chef_server_package['chef_server_core']['version']
  notifies :reconfigure, 'chef_server_ingredient[chef-server-core]'
end

chef_server_ingredient 'opscode-manage' do
  version chef_server_package['opscode_manage']['version']
  notifies :reconfigure, 'chef_server_ingredient[opscode-manage]'
end

file '/etc/opscode/chef-server.rb' do
  content <<-EOH
api_fqdn '#{node['fqdn']}'
dark_launch['actions'] = true
rabbitmq['vip'] = '#{node['ipaddress']}'
rabbitmq['node_ip_address'] = '0.0.0.0'
EOH
  notifies :reconfigure, 'chef_server_ingredient[chef-server-core]'
end
