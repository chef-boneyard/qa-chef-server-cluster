#
# Cookbook Name:: build
# Recipe:: provision_tier
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

run_chef_client('tier-cluster', attributes_file: attributes_install_file)
