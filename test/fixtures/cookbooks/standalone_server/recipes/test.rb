node.default['qa-chef-server-cluster']['chef-server-ctl-test-options'] = nil

include_recipe 'qa-chef-server-cluster::run-pedant'
