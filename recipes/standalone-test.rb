require 'chef/provisioning'

machine_execute 'chef-server-ctl test' do
  machine 'standalone'
end
