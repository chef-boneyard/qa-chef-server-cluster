#
# Cookbook Name:: build
# Recipe:: provision_tier_ec_upgrade_aws
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node.override['chef-server-acceptance']['identifier'] = 'ha-ec-upgrade'
node.override['chef-server-acceptance']['upgrade'] = true

include_recipe 'build::provision_general_prep'

repo = node['delivery']['workspace']['repo']
attributes_install_file = File.join(repo, 'install.json')
attributes_upgrade_file = File.join(repo, 'upgrade.json')

template attributes_install_file do
  source 'attributes.json.erb'
  action :create
  variables tags: { delivery_stage: node['delivery']['change']['stage'] },
            repo: 'omnibus-stable-local',
            flavor: 'enterprise_chef',
            chef_version: '11.3.2',
            integration_builds: false,
            image_id: node['ami']['ubuntu-12.04'],
            instance_type: 'm3.large'
end

# # must use non-default EC ha recipe, so we cannot use provision_ha recipe
# ruby_block 'stand-up-machine' do
#   block do
#     Dir.chdir qa_path
#     shell_out_retry("bundle exec chef-client -z -p 10257 -j #{attributes_install_file} -c #{repo_knife_file} -o qa-chef-server-cluster::ha-enterprise-chef-cluster --force-formatter")
#   end
# end

run_chef_client('ha-enterprise-chef-cluster', attributes_file: attributes_install_file)

# must use non-default EC ha recipe, so we cannot use provision_ha_generate_test_data_and_upgrade
include_recipe 'build::provision_ha_generate_test_data'
# 
# ruby_block 'upgrade-machine' do
#   block do
#     Dir.chdir qa_path
#     shell_out_retry("bundle exec chef-client -z -p 10257 -j #{attributes_upgrade_file} -c #{repo_knife_file} -o qa-chef-server-cluster::ha-enterprise-chef-cluster-upgrade --force-formatter")
#   end
# end

run_chef_client('ha-enterprise-chef-cluster-upgrade', attributes_file: attributes_upgrade_file)

include_recipe 'build::provision_ha_stage_db'
