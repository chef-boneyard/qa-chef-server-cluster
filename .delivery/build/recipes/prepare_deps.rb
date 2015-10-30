#
# Cookbook Name:: build
# Recipe:: prepare_deps
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# rubocop:disable LineLength

repo = node['delivery']['workspace']['repo']
install_dir = '/opt/chefdk'

execute "bundle install --path=#{node['gem_cache']}" do
  cwd repo
  environment(
    'PATH' => node['chef-server-acceptance']['delivery-path'],
    "LDFLAGS" => "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib",
    "CFLAGS" => "-I#{install_dir}/embedded/include"
  )
end

execute 'bundle exec berks vendor' do
  cwd repo
end

# rubocop:enable LineLength
