require 'chef/provisioning'

machine node['qa-chef-server-cluster']['standlone']['machine-name'] do
  action :destroy
end
