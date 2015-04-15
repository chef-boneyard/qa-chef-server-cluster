def install_chef_server_core_package
  omnibus_artifact 'chef-server' do
    integration_builds node['qa-chef-server-cluster']['chef-server']['install']['integration_builds']
    version node['qa-chef-server-cluster']['chef-server']['install']['version']
  end
end

def upgrade_chef_server_core_package
  omnibus_artifact 'chef-server' do
    integration_builds node['qa-chef-server-cluster']['chef-server']['upgrade']['integration_builds']
    version node['qa-chef-server-cluster']['chef-server']['upgrade']['version']
  end
end

def install_opscode_manage_package
  omnibus_artifact 'opscode-manage' do
    integration_builds node['qa-chef-server-cluster']['manage']['install']['integration_builds']
    version node['qa-chef-server-cluster']['manage']['install']['version']
    notifies :reconfigure, 'chef_server_ingredient[opscode-manage]'
    notifies :reconfigure, 'chef_server_ingredient[chef-server-core]'
  end
end

def upgrade_opscode_manage_package
  omnibus_artifact 'opscode-manage' do
    integration_builds node['qa-chef-server-cluster']['manage']['upgrade_opscode_manage']['integration_builds']
    version node['qa-chef-server-cluster']['manage']['upgrade_opscode_manage']['version']
    notifies :reconfigure, 'chef_server_ingredient[opscode-manage]'
    notifies :reconfigure, 'chef_server_ingredient[chef-server-core]'
  end
end

def should_install_opscode_manage?
  node['qa-chef-server-cluster']['manage']['install']['version'].empty? ? false : true
end

def should_upgrade_opscode_manage?
  node['qa-chef-server-cluster']['manage']['upgrade']['version'].empty? ? false : true
end

def run_chef_server_upgrade_procedure
  execute 'stop services' do
    command 'chef-server-ctl stop'
  end

  upgrade_chef_server_core_package

  execute 'upgrade server' do
    command 'chef-server-ctl upgrade'
  end

  execute 'start services' do
    command 'chef-server-ctl start'
  end
end
