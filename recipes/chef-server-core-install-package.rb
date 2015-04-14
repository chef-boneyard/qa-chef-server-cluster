omnibus_artifact 'chef-server' do
  integration_builds node['qa-chef-server-cluster']['chef-server']['install']['integration_builds']
  version node['qa-chef-server-cluster']['chef-server']['install']['version']
end
