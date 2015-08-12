file '/var/opt/opscode/drbd/drbd_ready'

chef_package 'private-chef' do
  action :reconfigure
end
