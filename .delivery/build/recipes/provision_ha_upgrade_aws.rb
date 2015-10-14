#
# Cookbook Name:: build
# Recipe:: provision_tier_ec_upgrade_aws
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node.override['chef-server-acceptance']['identifier'] = 'ha-upgrade'
node.override['chef-server-acceptance']['upgrade'] = true

include_recipe 'build::provision_general_prep'

cache = node['delivery']['workspace']['cache']
attributes_install_file = File.join(cache, 'install.json')
template attributes_install_file do
  source 'attributes.json.erb'
  action :create
  variables tags: { delivery_stage: node['delivery']['change']['stage'] },
            chef_version: node['chef_server_latest_released_version'],
            repo: node['chef_server_latest_released_repo'],
            integration_builds: node['chef_server_latest_released_integration_builds'],
            image_id: node['ami']['ubuntu-12.04']
end

include_recipe 'build::provision_ha'

include_recipe 'build::provision_ha_generate_test_data_and_upgrade'

include_recipe 'build::provision_ha_stage_db'

