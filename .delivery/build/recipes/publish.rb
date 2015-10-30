#
# Cookbook Name:: build
# Recipe:: publish
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
# This was lifted from delivery-truck publish

secrets = get_project_secrets
github_repo = node['delivery']['config']['delivery-truck']['publish']['github']

delivery_github github_repo do
  deploy_key secrets['github']
  branch node['delivery']['change']['pipeline']
  remote_url "git@github.com:#{github_repo}.git"
  repo_path node['delivery']['workspace']['repo']
  cache_path node['delivery']['workspace']['cache']
  action :push
end
