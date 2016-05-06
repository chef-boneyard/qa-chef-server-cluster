#
# Cookbook Name:: build
# Recipe:: provision_general_prep
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'build::prepare_deps'
include_recipe 'build::prepare_acceptance'

template attributes_install_file do
  source 'attributes.json.erb'
  variables(attribute_install_variables)
  action :create
end

template attributes_upgrade_file do
  source 'attributes.json.erb'
  action :create
  variables(attribute_upgrade_variables)
  only_if { node['chef-server-acceptance']['upgrade'] }
end
