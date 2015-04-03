omnibus_artifact 'chef-ha' do
  integration_builds node['qa-chef-server-cluster']['chef-ha']['install']['integration_builds']
  version node['qa-chef-server-cluster']['chef-ha']['install']['version']
end

