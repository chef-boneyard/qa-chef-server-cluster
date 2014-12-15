node.default['chef-server-cluster']['chef-provisioner-key-name'] = node['qa-chef-server-cluster']['chef-provisioner-key-name']
node.default['chef-server-cluster']['aws']['machine_options'] = node['qa-chef-server-cluster']['aws']['machine_options']

include_recipe 'chef-server-cluster::setup-provisioner'
include_recipe 'chef-server-cluster::setup-ssh-keys'

machine 'standalone' do
  recipe 'qa-chef-server-cluster::standalone-provision'
  action :converge
end
