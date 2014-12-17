include_recipe 'qa-chef-server-cluster::tier-cluster'
include_recipe 'qa-chef-server-cluster::tier-cluster-upgrade' if node['qa-chef-server-cluster']['enable-upgrade']
include_recipe 'qa-chef-server-cluster::tier-test'
include_recipe 'qa-chef-server-cluster::tier-destroy' if node['qa-chef-server-cluster']['auto-destroy']
