include_recipe 'qa-chef-server-cluster::provisioner-setup'

machine_execute 'chef-server-ctl stop keepalived' do
  machine 'bootstrap-backend'
end

# TODO (pwright)
ruby_block "ha failover" do
  block do
    sleep 300
  end
end

machine_batch do
  machine 'bootstrap-backend' do
    run_list [ 'qa-chef-server-cluster::verify-backend-backup' ]
  end
  machine 'secondary-backend' do
    run_list [ 'qa-chef-server-cluster::verify-backend-master' ]
  end
end