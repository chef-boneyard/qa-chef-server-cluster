chef_package 'chef-server-artifactory' do
  product_name 'chef-server'
  version '12.1.1'
  integration_builds false
  repository 'omnibus-stable-local'
  install_method 'artifactory'
  reconfigure true
end

chef_package 'chef-server-packagecloud' do
  product_name 'chef-server'
  version '12.1.1'
  install_method 'packagecloud'
end

chef_package 'chef-server-url' do
  product_name 'chef-server'
  version :latest
  install_method 'artifactory'
  package_url 'https://mydomain.com/package.ext'
end

chef_package 'no-version' do
  product_name 'manage'
  version nil
end
