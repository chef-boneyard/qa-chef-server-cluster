def download_bootstrap_files(machine_name = 'bootstrap-backend')
  # download server files
  %w{ actions-source.json webui_priv.pem }.each do |analytics_file|
    machine_file "/etc/opscode-analytics/#{analytics_file}" do
      local_path "#{node['qa-chef-server-cluster']['chef-server']['file-dir']}/#{analytics_file}"
      machine machine_name
      action :download
    end
  end

# download more server files
  %w{ pivotal.pem webui_pub.pem private-chef-secrets.json }.each do |opscode_file|
    machine_file "/etc/opscode/#{opscode_file}" do
      local_path "#{node['qa-chef-server-cluster']['chef-server']['file-dir']}/#{opscode_file}"
      machine machine_name
      action :download
    end
  end
end

def download_logs(machine_name)
  # create dedicated machine log directory
  machine_log_dir = directory ::File.join(Chef::Config[:chef_repo_path], '.chef', 'logs', machine_name) do
    mode 0700
    recursive true
  end

  # download chef-stacktrace.out if it exists
  machine_file ::File.join('', 'var', 'chef', 'cache', 'chef-stacktrace.out') do
    local_path ::File.join(machine_log_dir.name, 'chef-stacktrace.out')
    machine machine_name
    action :download
  end

  # run chef-server-ctl gather-logs and create symlink
  machine machine_name do
    run_list ['qa-chef-server-cluster::run-gather-logs']
  end

  # download gather logs archive if it exists
  machine_file ::File.join('', 'var', 'chef', 'cache', 'latest-gather-logs.tbz2') do
    local_path ::File.join(machine_log_dir.name, "#{machine_name}-logs.tbz2")
    machine machine_name
    action :download
  end

  # extract tarball for easy access
  execute "tar -xzvf #{machine_name}-logs.tbz2" do
    cwd machine_log_dir.name
    only_if { ::File.exists?("#{machine_log_dir.name}/#{machine_name}-logs.tbz2") }
  end
end
