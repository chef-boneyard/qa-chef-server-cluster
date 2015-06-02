node.default['qa-chef-server-cluster']['chef-provisioner-key-name'] = 'insecure-chef-provisioner'

node.default['qa-chef-server-cluster']['aws']['region'] = 'us-west-2'
node.default['qa-chef-server-cluster']['aws']['availability_zone'] = 'b'
node.default['qa-chef-server-cluster']['aws']['machine_options'] = {
                                                                     :aws_tags => { 'X-Project' => 'qa-chef-server-cluster' },
                                                                     :use_private_ip_for_ssh => true,
                                                                     :ssh_username => 'ubuntu',
                                                                     :bootstrap_options => {
                                                                       :key_name => 'qa-chef-server-cluster-default',
                                                                       :subnet_id => 'subnet-6fab6818', # QA Private
                                                                       :security_group_ids => ['sg-52a8f837'], # qa-chef-server-cluster
                                                                       :image_id => 'ami-3d50120d', # Ubuntu 14.04
                                                                       :instance_type => 'm3.medium'
                                                                     }
                                                                   }

node.default['qa-chef-server-cluster']['chef-server']['install']['version'] = :latest
node.default['qa-chef-server-cluster']['chef-server']['install']['integration_builds'] = false
node.default['qa-chef-server-cluster']['chef-server']['upgrade']['version'] = :latest
node.default['qa-chef-server-cluster']['chef-server']['upgrade']['integration_builds'] = true

node.default['qa-chef-server-cluster']['manage']['install']['version'] = nil
node.default['qa-chef-server-cluster']['manage']['install']['integration_builds']
node.default['qa-chef-server-cluster']['manage']['upgrade']['version'] = nil
node.default['qa-chef-server-cluster']['manage']['upgrade']['integration_builds']

node.default['qa-chef-server-cluster']['chef-ha']['install']['version'] = '1.0.0'
node.default['qa-chef-server-cluster']['chef-ha']['install']['integration_builds'] = true
node.default['qa-chef-server-cluster']['chef-ha']['upgrade']['version'] = nil
node.default['qa-chef-server-cluster']['chef-ha']['upgrade']['integration_builds']

node.default['qa-chef-server-cluster']['enable-upgrade'] = false
node.default['qa-chef-server-cluster']['auto-destroy'] = true
node.default['qa-chef-server-cluster']['run-pedant'] = true
node.default['qa-chef-server-cluster']['topology'] = 'standalone'

node.default['qa-chef-server-cluster']['chef-server']['api_fqdn'] = 'api.chef.sh'
