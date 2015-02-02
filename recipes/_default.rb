directory '/etc/opscode' do
  mode 0755
  recursive true
end

include_recipe 'apt::default'
include_recipe 'build-essential::default'

chef_server_ingredient 'chef-server-core' do
  action :nothing
end
