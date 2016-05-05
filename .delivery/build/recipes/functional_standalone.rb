#
# Cookbook Name:: build
# Recipe:: functional_standalone
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

run_chef_client('standalone-server-test', attributes_file: attributes_functional_file) if functional_test_all?
run_chef_client('standalone-server-destroy')
