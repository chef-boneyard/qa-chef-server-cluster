#
# Cookbook Name:: build
# Recipe:: prepare_deps
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

execute 'bundle install'

execute 'bundle exec berks vendor'
