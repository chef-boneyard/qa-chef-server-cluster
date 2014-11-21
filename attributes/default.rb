node.default['chef-server-cluster']['chef-provisioner-key-name'] = 'wrightp-metal-provisioner-aws'
node.default['chef-server-cluster']['aws']['machine_options']['bootstrap_options']['key_name'] = 'wrightp-metal-provisioner'

node.default['qa-chef-server-cluster']['standlone']['machine-name'] = 'standalone'

