#
# Cookbook Name:: build
# Recipe:: standalone_general_prep
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'build::prepare_deps'
include_recipe 'build::prepare_acceptance'

json_filename = if node['chef-server-acceptance']['upgrade'] == true
  'upgrade.json'
else
  'install.json'
end

template json_filename do
  source 'attributes.json.erb'
  action :create
  variables tags: { delivery_stage: node['delivery']['change']['stage'] },
            url: node['chef_server_test_url_override'],
            chef_version: node['chef_server_test_version'],
            repo: node['chef_server_test_repo'],
            integration_builds: node['chef_server_test_integration_builds'],
            image_id: node['ami']['ubuntu-12.04']
end
