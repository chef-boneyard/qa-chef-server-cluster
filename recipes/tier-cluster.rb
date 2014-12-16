include_recipe 'qa-chef-server-cluster::cluster-setup'

machine 'bootstrap-backend' do
  recipe 'qa-chef-server-cluster::bootstrap'
  ohai_hints 'ec2' => '{}'
  action :converge
end

%w{ pivotal.pem webui_pub.pem }.each do |opscode_file|

  machine_file "/etc/opscode/#{opscode_file}" do
    local_path "/tmp/stash/#{opscode_file}"
    machine 'bootstrap-backend'
    action :download
  end

end

machine 'frontend' do
  recipe 'qa-chef-server-cluster::frontend'
  recipe 'qa-chef-server-cluster::hosts-api-hack'
  ohai_hints 'ec2' => '{}'
  action :converge
  files(
        '/etc/opscode/webui_pub.pem' => '/tmp/stash/webui_pub.pem',
        '/etc/opscode/pivotal.pem' => '/tmp/stash/pivotal.pem'
       )
end

