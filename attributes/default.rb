node.default['qa-chef-server-cluster']['chef-provisioner-key-name'] = 'wrightp-metal-provisioner-aws'
node.default['qa-chef-server-cluster']['aws']['machine_options'] = {
                                                                     :use_private_ip_for_ssh => true,
                                                                     :bootstrap_options => {
                                                                       :key_name => 'wrightp-metal-provisioner',
                                                                       :subnet_id => 'subnet-6fab6818',
                                                                       :security_group_ids => ['sg-99aadefc']
                                                                     }
                                                                   }

node.default['qa-chef-server-cluster']['standalone']['machine-name'] = 'standalone'

# install specific version from packagecloud chef/stable
node.default['qa-chef-server-cluster']['chef-server-core']['version'] = nil
node.default['qa-chef-server-cluster']['opscode-manage']['version'] = nil

node.default['qa-chef-server-cluster']['chef-server-core']['upgrade-version'] = nil
node.default['qa-chef-server-cluster']['opscode-manage']['upgrade-version'] = nil


# install a package from a url location
node.default['qa-chef-server-cluster']['chef-server-core']['source'] = nil
node.default['qa-chef-server-cluster']['opscode-manage']['source'] = nil

node.default['qa-chef-server-cluster']['chef-server-core']['upgrade-source'] = nil
node.default['qa-chef-server-cluster']['opscode-manage']['upgrade-source'] = nil

node.default['qa-chef-server-cluster']['enable-upgrade'] = false
