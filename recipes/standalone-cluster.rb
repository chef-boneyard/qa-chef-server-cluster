node.default['chef-server-cluster']['chef-provisioner-key-name'] = node['qa-chef-server-cluster']['chef-provisioner-key-name']
node.default['chef-server-cluster']['aws']['machine_options']['bootstrap_options']['key_name'] = node['qa-chef-server-cluster']['aws']['machine_options']['bootstrap_options']['key_name']
node.default['chef-server-cluster']['aws']['machine_options']['bootstrap_options']['subnet_id'] = 'subnet-6fab6818'
node.default['chef-server-cluster']['aws']['machine_options']['bootstrap_options']['security_group_ids'] = ['sg-99aadefc']
node.default['chef-server-cluster']['aws']['machine_options']['use_private_ip_for_ssh'] = true

include_recipe 'chef-server-cluster::setup-provisioner'
include_recipe 'chef-server-cluster::setup-ssh-keys'

machine 'standalone' do
  recipe 'qa-chef-server-cluster::standalone-provision'
  action :converge
  converge true
end
