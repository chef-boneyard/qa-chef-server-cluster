source 'https://rubygems.org'

# group :acceptance do
#   gem 'berkshelf',             '~> 3.3.0'
#   gem 'chef',                  '~> 12.5.1'
#   gem 'chef-provisioning',     '~> 1.4.1'
#   gem 'chef-provisioning-aws', '~> 1.5.1'
#   gem 'chefspec', '~> 4.4.0'
# end

# c6c75773d5930ce77ab30ea21942515913b8d823
group :acceptance do
  gem 'berkshelf',             '3.3.0'
  gem 'chef',                  '12.4.1'
  # gem 'chef-provisioning',     '1.2.0'
  # gem 'chef-provisioning-aws', '1.3.0'
  gem 'chef-provisioning',     github: 'chef/chef-provisioning'
  gem 'chef-provisioning-aws', github: 'chef/chef-provisioning-aws'
end

group :development do
  gem 'mixlib-versioning'
end
