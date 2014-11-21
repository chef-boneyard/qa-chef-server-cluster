include_recipe 'qa-chef-server-cluster::standalone-default'

machine node['qa-chef-server-cluster']['standlone']['machine-name'] do
  action :destroy
end
