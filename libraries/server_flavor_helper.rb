module QaChefServerCluster
  class ChefServer
    attr_reader :product_name, :ctl_exec, :config_file, :config_path, :package_name

    def initialize(product_name:, ctl_exec:, config_file:, config_path:, package_name:)
      @product_name = product_name
      @ctl_exec = ctl_exec
      @config_file = config_file
      @config_path = config_path
      @package_name = package_name
    end
  end

  module ServerFlavorHelper
    def open_source_chef
      @open_source_chef = ChefServer.new(
        product_name: 'open_source_chef',
        ctl_exec: 'chef-server-ctl',
        config_file: 'chef-server.rb',
        config_path: '/etc/chef-server/',
        package_name: 'chef-server'
      )
    end

    def chef_server
      @chef_server = ChefServer.new(
        product_name: 'chef_server',
        ctl_exec: 'chef-server-ctl',
        config_file: 'chef-server.rb',
        config_path: '/etc/opscode/',
        package_name: 'chef-server'
      )
    end

    def enterprise_chef
      @enterprise_chef = ChefServer.new(
        product_name: 'enterprise_chef',
        ctl_exec: 'private-chef-ctl',
        config_file: 'private-chef.rb',
        config_path: '/etc/opscode/',
        package_name: 'private-chef'
      )
    end
  end
end
