include_recipe 'qa-chef-server-cluster::provisioner-setup'

machine 'frontend' do
  run_list ['qa-chef-server-cluster::run-pedant']
end
