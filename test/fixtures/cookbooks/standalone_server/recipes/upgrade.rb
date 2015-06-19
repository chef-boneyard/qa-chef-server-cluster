node.default['qa-chef-server-cluster']['chef-server-core']['version'] = :latest_current

include_recipe 'qa-chef-server-cluster::standalone-upgrade'
