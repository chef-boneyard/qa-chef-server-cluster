def run_pedant(machine)
  machine_execute 'chef-server-ctl test' do
    machine machine
  end
end

def download_bootstrap_files(machine = 'bootstrap-backend')
  # download server files
  %w{ actions-source.json webui_priv.pem }.each do |analytics_file|
    machine_file "/etc/opscode-analytics/#{analytics_file}" do
      local_path "#{node['qa-chef-server-cluster']['chef-server']['file-dir']}/#{analytics_file}"
      machine machine
      action :download
    end
  end

# download more server files
  %w{ pivotal.pem webui_pub.pem private-chef-secrets.json }.each do |opscode_file|
    machine_file "/etc/opscode/#{opscode_file}" do
      local_path "#{node['qa-chef-server-cluster']['chef-server']['file-dir']}/#{opscode_file}"
      machine machine
      action :download
    end
  end
end