directory '/etc/opscode' do
  mode 0755
  recursive true
end

chef_server_ingredient 'chef-server-core' do
  notifies :reconfigure, 'chef_server_ingredient[chef-server-core]'
end

chef_server_ingredient 'opscode-manage' do
  notifies :reconfigure, 'chef_server_ingredient[opscode-manage]'
end

file '/etc/opscode/private-chef.rb' do
  content <<-EOH
api_fqdn '#{node['fqdn']}'
dark_launch['actions'] = true
rabbitmq['vip'] = '#{node['ipaddress']}'
rabbitmq['node_ip_address'] = '0.0.0.0'
EOH
  notifies :reconfigure, 'chef_server_ingredient[chef-server-core]'
end
