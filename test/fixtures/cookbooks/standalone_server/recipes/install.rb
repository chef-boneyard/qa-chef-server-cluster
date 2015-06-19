node.default['qa-chef-server-cluster']['opscode-manage']['skip'] = true

include_recipe 'qa-chef-server-cluster::standalone'
