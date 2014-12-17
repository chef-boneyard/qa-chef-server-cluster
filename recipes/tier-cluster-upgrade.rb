include_recipe 'qa-chef-server-cluster::_cluster-setup'

machine 'bootstrap-backend' do
  recipe 'qa-chef-server-cluster::_bootstrap-upgrade'
  action :converge
end

machine 'frontend' do
  recipe 'qa-chef-server-cluster::_frontend-upgrade'
  action :converge
end
