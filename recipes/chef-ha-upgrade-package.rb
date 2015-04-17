omnibus_artifact 'chef-ha' do
  integration_builds node['qa-chef-server-cluster']['chef-ha']['upgrade']['integration_builds']
  version node['qa-chef-server-cluster']['chef-ha']['upgrade']['version']
end
