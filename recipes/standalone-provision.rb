directory '/etc/opscode' do
  mode 0755
  recursive true
end

if node['qa-chef-server-cluster']['chef-server-core']['source']
  remote_file '/tmp/chef-server-core.deb' do
    source node['qa-chef-server-cluster']['chef-server-core']['source']
  end

  # fix when we support another platform
  dpk_package 'chef-server-core' do
    source '/tmp/chef-server-core.deb'
  end
else
  chef_server_ingredient 'chef-server-core' do
    version node['qa-chef-server-cluster']['chef-server-core']['version']
  end
end

chef_server_ingredient 'chef-server-core' do
  action :reconfigure
end

if node['qa-chef-server-cluster']['opscode-manage']['source']
  remote_file '/tmp/opscode-manage.deb' do
    source node['qa-chef-server-cluster']['opscode-manage']['source']
  end

  # fix when we support another platform
  dpk_package 'opscode-manage' do
    source '/tmp/opscode-manage.deb'
  end
else
  # use ctl or not?  using ingredient we get more version control
  chef_server_ingredient 'opscode-manage' do
    version node['qa-chef-server-cluster']['opscode-manage']['version']
  end
end

chef_server_ingredient 'opscode-manage' do
  action :reconfigure
end

chef_server_ingredient 'chef-server-core' do
  action :reconfigure
end
