class Chef
  class Resource::OmnibusArtifact < Resource::LWRPBase
    self.resource_name = :omnibus_artifact

    actions :default
    default_action :default

     attribute :project,             name_attribute: true
     attribute :version,             kind_of: [String, Symbol]
     attribute :integration_builds,  kind_of: [TrueClass, FalseClass]
     attribute :install,             kind_of: [TrueClass, FalseClass], default: true
  end

  class Provider::OmnibusArtifact < Provider::LWRPBase
    action(:default) do
      artifact = omnibus_artifactory_artifact path do
        project new_resource.project
        integration_builds new_resource.integration_builds
        version new_resource.version
        platform value_for_platform_family(:debian => 'ubuntu', :rhel => 'el')
        platform_version node['platform_version']
      end

      pp artifact

      converge_by("Install #{path}") do
        properties = artifact.properties

        execute 'import keys for rhel' do
          command 'rpm --import https://downloads.chef.io/packages-chef-io-public.key'
          only_if { platform_family?('rhel') }
        end

        package ::File.basename(path) do
          source path
          provider value_for_platform_family(:debian => Chef::Provider::Package::Dpkg)
          version "#{properties['omnibus.version']}-#{properties['omnibus.iteration']}"
        end
      end if new_resource.install
    end

    private

    def path
      @path ||= ::File.join(Chef::Config[:file_cache_path],
        "#{new_resource.project}#{value_for_platform_family(:debian => '.deb', :rhel => '.rpm')}")
    end
  end
end
