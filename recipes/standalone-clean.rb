require 'chef/provisioning'

machine node['qa-chef-server-cluster']['standalone']['machine-name'] do
  action :destroy
end
