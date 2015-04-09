include_recipe 'qa-chef-server-cluster::provisioner-setup'

machine 'c' do
  action :allocate
end

machine 'c' do
  action :destroy
end

machine_batch do
  action :allocate
  machines 'd'
end

machine_batch do
  machines 'd'
  action :destroy
end

machine_batch do
  action :allocate
  machines 'a', 'b'
end

machine_batch do
  machines 'a', 'b'
  action :destroy
end

