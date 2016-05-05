#
# Cookbook Name:: build
# Recipe:: provision_standalone
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

run_chef_client('standalone-server', attributes_file: attributes_install_file)
