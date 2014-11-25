# include_recipe 'chef-server-cluster::setup-provisioner'
# include_recipe 'chef-server-cluster::setup-ssh-keys'

# machine_batch do
#   machines 'tier-backend', 'tier-frontend'
# end

# machine 'tier-backend' do
#   recipe 'qa-chef-server-cluster::bootstrap-backend-provision'
#   action :converge
#   converge true
# end

# machine_file '/etc/opscode/webui_pub.pem' do
#   local_path '/tmp/stash/webui_pub.pem'
#   machine 'tier-backend'
#   action :download
# end

# machine 'tier-frontend' do
#   recipe 'qa-chef-server-cluster::frontend-provision'
#   files '/etc/opscode/webui_pub.pem' => '/tmp/stash/webui_pub.pem'
#   action :converge
#   converge true
# end

node.default['chef-server-cluster']['chef-provisioner-key-name'] = node['qa-chef-server-cluster']['chef-provisioner-key-name'] 
node.default['chef-server-cluster']['aws']['machine_options']['bootstrap_options']['key_name'] = node['qa-chef-server-cluster']['aws']['machine_options']['bootstrap_options']['key_name']

include_recipe 'chef-server-cluster::cluster-provision'
