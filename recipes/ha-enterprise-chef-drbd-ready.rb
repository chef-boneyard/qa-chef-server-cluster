file '/var/opt/opscode/drbd/drbd_ready'

chef_package 'private-chef' do
  action :reconfigure
end

execute 'remove domain from pc0.res' do
  command 'sed -i s/.us-west-2.compute.internal/\/ /var/opt/opscode/drbd/etc/pc0.res'
end
