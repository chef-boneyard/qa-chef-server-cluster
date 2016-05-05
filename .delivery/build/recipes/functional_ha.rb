#
# Cookbook Name:: build
# Recipe:: functional_tier
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

run_chef_client('ha-cluster-test', attributes_file: attributes_functional_file) if functional_test_all?
run_chef_client('ha-cluster-destroy')
