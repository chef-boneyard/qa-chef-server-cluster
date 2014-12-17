chef_gem 'chef-provisioning-fog'
require 'chef/provisioning/fog_driver/driver'

# This requires that the desired AWS account to use is configured in
# ~/.aws/config as `default`.
with_driver("fog:AWS:default:#{node['qa-chef-server-cluster']['aws']['region']}")
with_machine_options(node['qa-chef-server-cluster']['aws']['machine_options'])

# This needs to move to a chef_vault_item, and use our internal `data`
# convention for the sub-key of where the secrets are. It should also
# use an attribute for the name, so basically uncomment this line when
# we're ready for that.
#ssh_keys = chef_vault_item('vault', node['chef-server-cluster']['chef-provisioner-key-name'])['data']
ssh_keys = data_bag_item('secrets', node['qa-chef-server-cluster']['chef-provisioner-key-name'])

directory '/tmp/ssh' do
  recursive true
end

directory '/tmp/stash' do
  recursive true
end

file '/tmp/ssh/id_rsa' do
  content ssh_keys['private_ssh_key']
  sensitive true
end

file '/tmp/ssh/id_rsa.pub' do
  content ssh_keys['public_ssh_key']
  sensitive true
end

fog_key_pair node['qa-chef-server-cluster']['aws']['machine_options']['bootstrap_options']['key_name'] do
  private_key_path '/tmp/ssh/id_rsa'
  public_key_path '/tmp/ssh/id_rsa.pub'
end

