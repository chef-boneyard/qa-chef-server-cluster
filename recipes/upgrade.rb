case node['qa-chef-server-cluster']['topology']
when 'standalone'
  include_recipe 'qa-chef-server-cluster::standalone-server-upgrade'
when 'tier'
  include_recipe 'qa-chef-server-cluster::tier-cluster-upgrade'
when 'ha'
  include_recipe 'qa-chef-server-cluster::ha-cluster-upgrade'
else
  raise "Must set topology"
end
