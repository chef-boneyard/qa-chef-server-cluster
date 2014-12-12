# https://docs.chef.io/upgrade_server.html#standalone

chef_server_package = data_bag_item('chef_server', 'package').to_hash

remote_file '/tmp/chef-server-core.deb' do
  source chef_server_package['chef_server_core']['source']
end

execute 'stop services' do
  command 'chef-server-ctl stop'
end

dpkg_package 'chef-server-core' do
  source '/tmp/chef-server-core.deb'
end

execute 'upgrade server' do
  command 'chef-server-ctl upgrade'
end

execute 'start services' do
  command 'chef-server-ctl start'
end

chef_server_ingredient 'opscode-manage' do
  action :reconfigure
end

execute 'cleanup server' do
  command 'chef-server-ctl cleanup'
end
