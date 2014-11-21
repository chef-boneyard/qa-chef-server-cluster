include_recipe 'qa-chef-server-cluster::standalone-default'
include_recipe 'chef-server-cluster::setup-ssh-keys'

machine node['qa-chef-server-cluster']['standlone']['machine-name'] do
  recipe 'qa-chef-server-cluster::standalone-provision'
  action :converge
  converge true
end
