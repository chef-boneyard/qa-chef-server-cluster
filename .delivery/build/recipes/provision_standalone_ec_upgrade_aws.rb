#
# Cookbook Name:: build
# Recipe:: provision_standalone_ec_upgrade_aws
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# rubocop:disable LineLength

node.override['chef-server-acceptance']['identifier'] = 'standalone-ec-upgrade'
node.override['chef-server-acceptance']['upgrade'] = true

include_recipe 'build::provision_general_prep'

cache = node['delivery']['workspace']['cache']
attributes_install_file = File.join(cache, 'install.json')
template attributes_install_file do
  source 'attributes.json.erb'
  action :create
  variables tags: { delivery_stage: node['delivery']['change']['stage'] },
            repo: 'omnibus-stable-local',
            flavor: 'enterprise_chef',
            chef_version: '11.3.2',
            integration_builds: false,
            image_id: node['ami']['ubuntu-12.04']
end

include_recipe 'build::provision_standalone'

include_recipe 'build::provision_standalone_generate_test_data_and_upgrade'

include_recipe 'build::provision_standalone_stage_db'

