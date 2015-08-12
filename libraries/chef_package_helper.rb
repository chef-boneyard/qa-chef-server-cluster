require_relative './server_flavor_helper'

module QaChefServerCluster
  module ChefPackageHelper
    include ChefIngredientCookbook::Helpers
    include QaChefServerCluster::ServerFlavorHelper

    #
    #
    #
    def install_product(resource)
      if resource.package_url
        install_via_url(resource.package_url)
        reconfigure_product(resource) if resource.reconfigure
      elsif resource.version.nil?
        Chef::Log.info "#{resource.product_name} version not set. Not installing package."
      else
        case resource.install_method
        when 'artifactory'
          install_via_artifactory(resource.product_name,
            resource.version,
            resource.integration_builds,
            resource.repository)

        when 'packagecloud'
          install_via_packagecloud(resource.product_name,
            resource.version)

        when 'chef-server-ctl'
          # TODO Should we even handle a server name exception?  Perhaps a whitelist would be better.
          install_command = "chef-server-ctl install #{chef_ingredient_product_lookup}"
          #install_command << " --path "if resource.package_source
          execute install_command

        else
          raise "Must provide a URL or install method."
        end
        reconfigure_product(resource) if resource.reconfigure
      end
    end

    #
    #
    #
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

    def install_via_artifactory(package_name, package_version, integration_builds, repo)
      # TODO what's the deal with chef-manage?????
      if package_name == 'chef-manage'
        package_name = 'opscode-manage' 
        # chef-server-core and chef-server are both in the chef-server repo
      elsif package_name == 'chef-server'
        package_name
      else
        package_name = chef_ingredient_product_lookup
      end

      omnibus_artifactory_artifact package_name do
        version package_version
        integration_builds integration_builds
        repo repo
      end

      chef_ingredient package_name do
        package_source omnibus_artifactory_artifact_local_path(package_name)
      end
    end

    def install_via_packagecloud(package_name, package_version)
      ['stable', 'current'].each do |repo|
        packagecloud_repo "chef/#{repo}" do
          type value_for_platform_family(:rhel => 'rpm', :debian => 'deb') 
        end
      end

      chef_ingredient package_name do
        version package_version
      end
    end

    def install_via_url(url)
      local_source = "#{::File.join(Chef::Config.file_cache_path, 
        ::File.basename(url))}"
      remote_file local_source do
        source url
      end

      chef_ingredient "#{::File.basename(url)}" do
         package_source local_source
      end
    end

    def run_chef_server_upgrade_procedure(resource)
      server = upgrade_from_server_flavor(installed_chef_server_packages)
      execute "#{server.ctl_exec} stop"

      if resource.reconfigure
        Chef::Log.info "reconfigure was set to true during a Chef Server upgrade. To prevent upgrade issues this will be ignored."
        resource.reconfigure(false)
      end

      install_product(resource)

      upgrade_command = "#{current_server.ctl_exec} upgrade"
      # TODO configurable osc upgrade options
      upgrade_command << ' --yes --org-name chef --full-org-name "Chef Org"' if server.product_name == 'open_source_chef'
  
      execute upgrade_command

      execute "#{current_server.ctl_exec} start" do
        not_if { server.product_name == 'open_source_chef' }
      end
    end
  end
end
