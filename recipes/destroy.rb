case node['qa-chef-server-cluster']['topology']
when 'standalone'
  include_recipe 'qa-chef-server-cluster::standalone-server-destroy'
when 'tier'
  include_recipe 'qa-chef-server-cluster::tier-cluster-destroy'
when 'ha'
  include_recipe 'qa-chef-server-cluster::ha-cluster-destroy'
else
  raise "Must set topology"
end
