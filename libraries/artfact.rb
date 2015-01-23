class Chef
  class Resource::Artifact < Resource::LWRPBase
    self.resource_name = :artifact

    actions :default
    default_action :default

     attribute :project,             name_attribute: true
     attribute :version,             kind_of: [String, Symbol]
     attribute :integration_builds,  kind_of: [TrueClass, FalseClass]
     attribute :install,             kind_of: [TrueClass, FalseClass], default: true
  end

  class Provider::Artifact < Provider::LWRPBase
    action(:default) do
      omnibus_artifactory_artifact path do
        project new_resource.project
        integration_builds new_resource.integration_builds
        version new_resource.version
        platform value_for_platform_family(:debian => 'ubuntu', :rhel => 'el')
        platform_version node['platform_version']
        install new_resource.install
      end
    end
    
    private

    def path
      @path ||= ::File.join(Chef::Config[:file_cache_path], 
        "#{new_resource.project}#{value_for_platform_family(:debian => '.deb', :rhel => '.rpm')}") 
    end
  end
end
