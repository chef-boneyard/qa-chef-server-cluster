require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  # Specify the path for Chef Solo to find cookbooks (default: [inferred from
  # the location of the calling spec file])
  # config.cookbook_path = '/var/cookbooks'

  # Specify the path for Chef Solo to find roles (default: [ascending search])
  # config.role_path = '/var/roles'

  # Specify the path for Chef Solo to find environments (default: [ascending search])
  # config.environment_path = '/var/environments'

  # Specify the path for Chef Solo file cache path (default: nil)
  config.file_cache_path = '/var/chef/cache'

  # Specify the Chef log_level (default: :warn)
  # config.log_level = :debug

  # Specify the path to a local JSON file with Ohai data (default: nil)
  # config.path = 'ohai.json'

  # Specify the operating platform to mock Ohai data from (default: nil)
  # config.platform = 'ubuntu'

  # Specify the operating version to mock Ohai data from (default: nil)
  # config.version = '12.04'
end

at_exit { ChefSpec::Coverage.report! }
