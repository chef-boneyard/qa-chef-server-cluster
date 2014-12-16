require 'chef/provisioning'

machine_batch do
  machines 'bootstrap-backend', 'frontend'
  action :destroy
end
