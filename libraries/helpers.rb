#
# Cookbook Name:: qa-chef-server-cluster
# Libraries:: helpers
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

SUPPORTED_FLAVORS = [:chef_server, :open_source_chef, :enterprise_chef]

def install_chef_server(package_version: node['qa-chef-server-cluster']['chef-server']['version'],
      integration_builds: node['qa-chef-server-cluster']['chef-server']['integration_builds'],
      repo: node['qa-chef-server-cluster']['chef-server']['repo'])
  if should_install?('chef-server')
    case current_flavor
    when :chef_server, :open_source_chef, nil
      install_package('chef-server', package_version, integration_builds, repo)
    when :enterprise_chef
      install_package('private-chef', package_version, integration_builds, repo)
    end
  end
end

def reconfigure_chef_server
  case current_flavor
  when :chef_server, :open_source_chef
    chef_ingredient 'chef-server' do
      action :reconfigure
    end
  when :enterprise_chef
    chef_ingredient 'private-chef' do
      action :reconfigure
    end
  end
end

def install_opscode_manage(package_version: node['qa-chef-server-cluster']['opscode-manage']['version'],
      integration_builds: node['qa-chef-server-cluster']['opscode-manage']['integration_builds'],
      repo: node['qa-chef-server-cluster']['opscode-manage']['repo'])
  if should_install?('opscode-manage')
    install_package('opscode-manage', package_version, integration_builds, repo)

    chef_server_ingredient 'opscode-manage' do
      action :reconfigure
    end
  end
end

def install_chef_ha(package_version: node['qa-chef-server-cluster']['chef-ha']['version'],
      integration_builds: node['qa-chef-server-cluster']['chef-ha']['integration_builds'],
      repo: node['qa-chef-server-cluster']['chef-ha']['repo'])
  if should_install?('chef-ha')
    install_package('chef-ha', package_version, integration_builds, repo)
  end
end

def install_package(package_name, package_version, integration_builds = nil, repo = nil)
  if install_from_source?(package_version)
    local_source = "#{::File.join(Chef::Config.file_cache_path, ::File.basename(package_version))}"
    remote_file local_source do
      source package_version
    end

    package package_name do
      source local_source
      provider value_for_platform_family(:debian => Chef::Provider::Package::Dpkg)
    end
  else
    omnibus_artifact package_name do
      version package_version
      integration_builds integration_builds
      repo repo
    end
  end
end

def install_from_source?(version)
  (version =~ /\A#{URI::regexp(['http', 'https'])}\z/) == 0 ? true : false
end

def run_chef_server_upgrade_procedure
  if should_install?('chef-server')
    execute 'stop services' do
      command 'chef-server-ctl stop'
    end

    install_chef_server

    upgrade_chef_server

    execute 'start services' do
      command 'chef-server-ctl start'
      not_if { upgrade_from_flavor == :open_source_chef }
    end
  end
end

def check_backend_ha_status(expected_status)
  ruby_block "is #{expected_status} backend?" do
    block do
      current_cluster_status = Mixlib::ShellOut.new("cat /var/opt/opscode/keepalived/current_cluster_status")
      current_cluster_status.run_command
      server_status = current_cluster_status.stdout.strip!
      if server_status != expected_status
        raise "Expected cluster status '#{expected_status}', but got actual status '#{server_status}'"
      else
        Chef::Log.info "backend has taken over as #{expected_status}!"
      end
    end
    # retry every 15 secs for 10 mins
    retries 4 * 10
    retry_delay 15
  end
end

def should_install?(package)
  node['qa-chef-server-cluster'][package]['skip'] == false ? true : false
end

def current_flavor
  flavor = node['qa-chef-server-cluster']['chef-server']['flavor']
  flavor = flavor.to_sym if flavor.is_a?(String)
  unless SUPPORTED_FLAVORS.include?(flavor)
    raise "Chef Server flavor #{flavor} not supported.  Must be one of: #{supported_flavors}"
  end
  flavor
end

# TODO Make this determine the currently installed chef server flavor via the system automatically
def upgrade_from_flavor
  flavor = node['qa-chef-server-cluster']['chef-server']['upgrade_from_flavor']
  flavor = flavor.to_sym if flavor.is_a?(String)
  unless SUPPORTED_FLAVORS.include?(flavor)
    raise "Chef Server upgrade flavor #{flavor} not supported.  Must be one of: #{supported_flavors}"
  end
  flavor
end

def upgrade_chef_server
  case upgrade_from_flavor
  when :chef_server, nil
    execute 'upgrade chef server' do
      command 'chef-server-ctl upgrade'
    end
  when :open_source_chef
    execute 'upgrade open source chef to chef server' do
      command 'chef-server-ctl upgrade --yes --org-name chef --full-org-name "Chef Org"'
    end
  when :enterprise_chef
  end
end
