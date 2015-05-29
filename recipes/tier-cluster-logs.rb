include_recipe 'qa-chef-server-cluster::provisioner-setup'

download_logs 'bootstrap-backend'
download_logs 'frontend'
