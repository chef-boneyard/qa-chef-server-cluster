#
# Cookbook Name:: qa-chef-server-cluster
# Libraries:: provisioner_helpers
#
# Author: Patrick Wright <patrick@chef.io>
# Copyright (C) 2015, Chef Software, Inc. <legal@getchef.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

def download_bootstrap_files(machine_name = node['bootstrap-backend'])
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
  machine_log_dir = directory ::File.join(Chef::Config[:chef_repo_path], 'logs', machine_name) do
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

  # TODO Commenting this for now.  This will be useful once we can archive
  # and view output files in Delivery.  Then we can work out the details.
  # For now, extracting this way is causing failures.
  # extract tarball for easy access
  # execute "`which tar` -xzvf #{machine_name}-logs.tbz2" do
  #   cwd machine_log_dir.name
  #   only_if { ::File.exists?("#{machine_log_dir.name}/#{machine_name}-logs.tbz2") }
  # end
end

def symbolize_keys_deep!(h)
  Chef::Log.debug("#{h.inspect} is a hash with string keys, make them symbols")
  h.keys.each do |k|
    ks    = k.to_sym
    h[ks] = h.delete k
    symbolize_keys_deep! h[ks] if h[ks].kind_of? Hash
  end
end
