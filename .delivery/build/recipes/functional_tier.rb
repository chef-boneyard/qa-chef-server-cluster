#
# Cookbook Name:: build
# Recipe:: functional_tier
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

repo = node['delivery']['workspace']['repo']
attributes_functional_file = File.join(repo, 'functional.json')

# Disable chef-server-test --all for now
# run_chef_client('tier-cluster-test', attributes_file: attributes_functional_file)
run_chef_client('tier-cluster-destroy')
