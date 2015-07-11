case node['qa-chef-server-cluster']['topology']
when 'standalone'
  include_recipe 'qa-chef-server-cluster::standalone-server-generate-test-data'
when 'tier'
  include_recipe 'qa-chef-server-cluster::tier-cluster-generate-test-data'
when 'ha'
  include_recipe 'qa-chef-server-cluster::ha-cluster-generate-test-data'
else
  raise "Must set topology"
end
