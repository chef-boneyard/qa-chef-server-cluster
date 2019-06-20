require_relative './server_flavor_helper'

module QaChefServerCluster
  module ChefPackageHelper
    include ChefIngredientCookbook::Helpers
    include QaChefServerCluster::ServerFlavorHelper

    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/AbcSize
    def install_product(resource)
      if resource.package_url
        install_via_url(resource)
      elsif resource.version.nil?
        Chef::Log.info "#{resource.product_name} version not set. Not installing package."
      else
        install_via_channel(resource)
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/AbcSize

    def reconfigure_product(resource)
      ensure_mixlib_versioning_gem_installed!
      chef_ingredient resource.product_name do
        ENV['CHEF_LICENSE']="accept"
        action :reconfigure
      end
    end

    def install_via_channel(resource)
      chef_ingredient resource.product_name do
        channel resource.channel.to_sym
        version resource.version
        config resource.config
      end

      ingredient_config resource.product_name do
        only_if { resource.config }
      end

      reconfigure_product(resource) if resource.reconfigure
    end

    # rubocop:disable Metrics/AbcSize
    def install_via_url(resource)
      local_source = ::File.join(Chef::Config.file_cache_path,
                                 ::File.basename(resource.package_url))
      remote_file local_source do
        source resource.package_url
      end

      chef_ingredient resource.product_name do
        package_source local_source
        config resource.config
      end

      ingredient_config resource.product_name do
        only_if { resource.config }
      end

      reconfigure_product(resource) if resource.reconfigure
    end
    # rubocop:enable Metrics/AbcSize

    # rubocop:disable Metrics/AbcSize
    def run_chef_server_upgrade_procedure(resource)
      server = upgrade_from_server_flavor(installed_chef_server_packages)
      execute "#{server.ctl_exec} stop"

      if resource.reconfigure
        Chef::Log.info 'reconfigure was set to true during a Chef Server upgrade. To prevent upgrade issues this will be ignored.'
        resource.reconfigure(false)
      end

      install_product(resource)

      upgrade_command = "#{current_server.ctl_exec} upgrade"
      # TODO: configurable osc upgrade options
      upgrade_command << ' --yes --org-name chef --full-org-name "Chef Org"' if server.product_name == 'open_source_chef'

      execute upgrade_command

      execute "#{current_server.ctl_exec} start" do
        not_if { server.product_name == 'open_source_chef' }
      end
    end
    # rubocop:enable Metrics/AbcSize
  end
end
