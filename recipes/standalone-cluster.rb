include_recipe 'qa-chef-server-cluster::cluster-setup'

machine 'standalone' do
  recipe 'qa-chef-server-cluster::standalone-provision'
  ohai_hints 'ec2' => '{}'
  action :converge
end
