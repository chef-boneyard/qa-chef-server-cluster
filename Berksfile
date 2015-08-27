source 'https://supermarket.getchef.com'

metadata

cookbook 'chef-vault'
cookbook 'apt'
cookbook 'chef-ingredient'
cookbook 'lvm'
cookbook 'omnibus-artifactory-artifact', git: 'git@github.com:opscode-cookbooks/omnibus-artifactory-artifact.git', branch: 'master'
cookbook 'packagecloud'

def fixture(name)
  cookbook "#{name}", path: "test/fixtures/cookbooks/#{name}"
end

group :integration do
  fixture 'chef_package_resource'
end
