file '/var/opt/opscode/drbd/drbd_ready'

chef_package 'private-chef' do
  action :reconfigure
  notifies :run, 'execute[remove domain from pc0.res]', :immediately
end

execute 'remove domain from pc0.res' do
  action :nothing
  command 'sed -i s/.us-west-2.compute.internal/\/ /var/opt/opscode/drbd/etc/pc0.res'
end
