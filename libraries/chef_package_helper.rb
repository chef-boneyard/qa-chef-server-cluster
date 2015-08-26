require_relative './server_flavor_helper'

module QaChefServerCluster
  module ChefPackageHelper
    include ChefIngredientCookbook::Helpers
    include QaChefServerCluster::ServerFlavorHelper

    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/AbcSize
    # TODO: Fix this nasty method
    def install_product(resource)
      if resource.package_url
        install_via_url(resource)
        reconfigure_product(resource) if resource.reconfigure
      elsif resource.version.nil?
        Chef::Log.info "#{resource.product_name} version not set. Not installing package."
      else
        case resource.install_method
        when 'artifactory'
          install_via_artifactory(resource)
        when 'packagecloud'
          install_via_packagecloud(resource)
        when 'chef-server-ctl'
          # TODO: Should we even handle a server name exception?  Perhaps a whitelist would be better.
          install_command = "chef-server-ctl install #{chef_ingredient_product_lookup}"
          # install_command << " --path "if resource.package_source
          execute install_command

        else
          raise 'Must provide a URL or install method.'
        end
        reconfigure_product(resource) if resource.reconfigure
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/AbcSize

    def reconfigure_product(resource)
      install_mixlib_versioning
      chef_ingredient resource.product_name do
        action :reconfigure
      end
    end

    def chef_ingredient_product_lookup
      install_mixlib_versioning
      ingredient_package_name
    end

    # rubocop:disable Metrics/AbcSize
    def install_via_artifactory(resource)
      # TODO: what's the deal with chef-manage?????
      if resource.product_name == 'chef-manage'
        resource.product_name('opscode-manage')
        # chef-server-core and chef-server are both in the chef-server repo
      elsif resource.product_name == 'chef-server'
        resource.product_name
      else
        resource.product_name(chef_ingredient_product_lookup)
      end

      omnibus_artifactory_artifact resource.product_name do
        version resource.version
        integration_builds resource.integration_builds
        repo resource.repository
      end

      chef_ingredient resource.product_name do
        package_source omnibus_artifactory_artifact_local_path(resource.product_name)
        config resource.config
      end

      ingredient_config resource.product_name do
        only_if { resource.config }
      end
    end
    # rubocop:enable Metrics/AbcSize

    def install_via_packagecloud(resource)
      ['stable', 'current'].each do |repo|
        packagecloud_repo "chef/#{repo}" do
          type value_for_platform_family(:rhel => 'rpm', :debian => 'deb')
        end
      end

      chef_ingredient resource.product_name do
        version resource.version
        config resource.config
      end

      ingredient_config resource.product_name do
        only_if { resource.config }
      end
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
