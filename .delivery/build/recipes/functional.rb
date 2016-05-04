#
# Cookbook Name:: build
# Recipe:: functional
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# if we are not in the URD run pedant
if node['delivery']['change']['stage'] == 'acceptance'
  # This is necessary for delivery-matrix to catch failures in earlier steps.
  # Without including this recipe, the parent job will report success even if the
  # child job failed.
  include_recipe 'delivery-matrix::functional'

# this is the only part of the URD we are using currently, publish to github
elsif node['delivery']['change']['stage'] == 'delivered'
  # TODO this is to publish to github
  # we currently have no need for this, but if we wanna use it,
  # we need to make a repo on github and change the config in the project json

  # secrets = get_project_secrets
  # github_repo = node['delivery']['config']['delivery-truck']['publish']['github']

  # delivery_github github_repo do
  #   deploy_key secrets['github']
  #   branch node['delivery']['change']['pipeline']
  #   remote_url "git@github.com:#{github_repo}.git"
  #   repo_path node['delivery']['workspace']['repo']
  #   cache_path node['delivery']['workspace']['cache']
  #   action :push
  # end
end

