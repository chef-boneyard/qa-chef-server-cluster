include_recipe 'qa-chef-server-cluster::standalone-cluster'
include_recipe 'qa-chef-server-cluster::standalone-cluster-upgrade' if node['qa-chef-server-cluster']['enable-upgrade']
include_recipe 'qa-chef-server-cluster::standalone-test'
include_recipe 'qa-chef-server-cluster::standalone-clean'
