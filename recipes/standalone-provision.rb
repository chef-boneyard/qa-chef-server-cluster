directory '/etc/opscode' do
  mode 0755
  recursive true
end

chef_server_core_source = node['qa-chef-server-cluster']['chef-server-core']['source']
opscode_manage_source   = node['qa-chef-server-cluster']['opscode-manage']['source']

if chef_server_core_source
  remote_file '/tmp/chef-server-core.deb' do
    source chef_server_core_source
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

if opscode_manage_source
  remote_file '/tmp/opscode-manage.deb' do
    source opscode_manage_source
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
