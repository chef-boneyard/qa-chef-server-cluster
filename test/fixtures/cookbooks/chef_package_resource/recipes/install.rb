chef_package 'chef-server-artifactory' do
  product_name 'chef-server'
  version '12.1.1'
  channel 'stable'
  reconfigure true
end

chef_package 'chef-server-packagecloud' do
  product_name 'chef-server'
  version '12.1.1'
end

chef_package 'chef-server-url' do
  product_name 'chef-server'
  version :latest
  package_url 'https://mydomain.com/package.ext'
end

chef_package 'no-version' do
  product_name 'manage'
  version nil
end
