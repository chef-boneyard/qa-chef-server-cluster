node.default['chef-server-cluster']['chef-provisioner-key-name'] = node['qa-chef-server-cluster']['chef-provisioner-key-name'] 
node.default['chef-server-cluster']['aws']['machine_options']['bootstrap_options']['key_name'] = node['qa-chef-server-cluster']['aws']['machine_options']['bootstrap_options']['key_name']

include_recipe 'chef-server-cluster::cluster-provision'

# Uses hosts file since we are not using DNS at this time
machine 'frontend' do
  recipe 'qa-chef-server-cluster::hosts-api-hack'
  action :converge
end
