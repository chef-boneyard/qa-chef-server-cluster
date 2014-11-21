include_recipe 'qa-chef-server-cluster::standalone-default'

machine_execute 'chef-server-ctl test' do
  machine node['qa-chef-server-cluster']['standlone']['machine-name']
end
