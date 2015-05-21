include_recipe 'qa-chef-server-cluster::provisioner-setup'

machine 'standalone' do
  run_list ['qa-chef-server-cluster::run-pedant']
end
