def install_chef_server_core(package_version: node['qa-chef-server-cluster']['chef-server-core']['install'], reconfigure: true)
  install_package('chef-server-core', package_version, reconfigure)
end

def upgrade_chef_server_core(package_version: node['qa-chef-server-cluster']['chef-server-core']['upgrade'], reconfigure: true)
  install_package('chef-server-core', package_version, reconfigure)
end

def install_opscode_manage(package_version: node['qa-chef-server-cluster']['opscode-manage']['install'])
  install_package('opscode-manage', package_version)
end

def upgrade_opscode_manage(package_version: node['qa-chef-server-cluster']['opscode-manage']['upgrade'])
  install_package('opscode-manage', package_version)
end

def install_package(package_name, package_version = nil, reconfigure = true)
  local_source = nil
  if install_from_source?(package_version)
    local_source = "#{::File.join(Chef::Config.file_cache_path, ::File.basename(package_version))}"
    remote_file local_source do
      source package_version
    end
  end
  
  actions = [:install]
  actions << :reconfigure if reconfigure
  chef_server_ingredient package_name do
    # install then reconfigure if set
    action actions
    # install from local source if downloaded via URL
    package_source local_source if !local_source.nil?
    # specify version. nil version will install 'latest current'. ignore version setting if local source is set
    version format_version(package_version) if !package_version.nil? && local_source.nil?
  end
end

def install_from_source?(version)
  (version =~ /\A#{URI::regexp(['http', 'https'])}\z/) == 0 ? true : false
end

# append '-1' package iteration number to version if not provided
# otherwise packagecloud won't find a package to install
def format_version(version)
  version =~ /.*-\d$/ ? version : "#{version}-1"
end
