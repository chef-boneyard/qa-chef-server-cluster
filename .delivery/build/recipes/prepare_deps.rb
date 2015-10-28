#
# Cookbook Name:: build
# Recipe:: prepare_deps
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# rubocop:disable LineLength

path = node['delivery']['workspace']['repo']
# dbuild readable folder that is persistent between build runs that we created in the default recipe
gem_cache = File.join(node['delivery']['workspace']['root'], "../../../project_gem_cache")

deps_path = "#{path}/deps"

# install qa-chef-server-cluster as a dep
directory deps_path do
  # set the owner to the dbuild so that the other recipes can write to here
  owner node['delivery_builder']['build_user']
  mode "0755"
  recursive true
  action :create
end

qa_path = "#{deps_path}/qa-chef-server-cluster"

directory qa_path do
  action :delete
  recursive true
end

execute 'git clone git@github.com:chef/qa-chef-server-cluster.git' do
  cwd deps_path
end

execute 'git checkout c6c75773d5930ce77ab30ea21942515913b8d823' do
  cwd qa_path
end

directory "#{qa_path}/.chef" do
  owner node['delivery_builder']['build_user']
  mode '0755'
  action :create
end

file "#{qa_path}/.chef/knife.rb" do
  mode '0644'
  action :create
  content "ssl_verify_mode :verify_none"
end

install_dir = '/opt/chefdk'
execute "bundle install --path=#{gem_cache}" do
  cwd qa_path
  environment(
    'PATH' => node['chef-server-acceptance']['delivery-path'],
    "LDFLAGS" => "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib",
    "CFLAGS" => "-I#{install_dir}/embedded/include"
  )
end

execute 'bundle exec berks vendor' do
  cwd path
end

# rubocop:enable LineLength
