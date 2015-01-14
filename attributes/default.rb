node.default['qa-chef-server-cluster']['chef-provisioner-key-name'] = 'insecure-chef-provisioner'

node.default['qa-chef-server-cluster']['aws']['region'] = 'us-west-2'
node.default['qa-chef-server-cluster']['aws']['machine_options'] = {
                                                                     :use_private_ip_for_ssh => true,
                                                                     :ssh_username => 'ubuntu',
                                                                     :bootstrap_options => {
                                                                       :key_name => 'qa-chef-server-cluster-default',
                                                                       :subnet_id => 'subnet-6fab6818',
                                                                       :security_group_ids => ['sg-99aadefc'],
                                                                       :image_id => 'ami-eb5b19db',
                                                                       :flavor_id => 'm3.medium'
                                                                     }
                                                                   }

node.default['qa-chef-server-cluster']['chef-server-core']['source'] = nil
node.default['qa-chef-server-cluster']['opscode-manage']['source'] = nil

node.default['qa-chef-server-cluster']['chef-server-core']['upgrade-source'] = nil
node.default['qa-chef-server-cluster']['opscode-manage']['upgrade-source'] = nil

node.default['qa-chef-server-cluster']['enable-upgrade'] = false

node.default['qa-chef-server-cluster']['auto-destroy'] = true
