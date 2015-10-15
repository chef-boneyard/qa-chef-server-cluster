#
# Cookbook Name:: build
# Recipe:: prepare_acceptance
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# rubocop:disable LineLength

delivery_secrets = get_project_secrets
path             = node['delivery']['workspace']['repo']
cache            = node['delivery']['workspace']['cache']

ssh_private_key_path =  File.join(cache, '.ssh', 'chef-server-build-key')
ssh_public_key_path  =  File.join(cache, '.ssh', 'chef-server-build-key.pub')

%w( .ssh .aws ).each do |dir|
  directory File.join(cache, dir) do
    action :create
  end
end

file ssh_private_key_path do
  sensitive true
  content delivery_secrets['private_key']
  owner node['delivery_builder']['build_user']
  group node['delivery_builder']['build_user']
  mode '0600'
end

file ssh_public_key_path do
  content delivery_secrets['public_key']
  owner node['delivery_builder']['build_user']
  group node['delivery_builder']['build_user']
  mode '0644'
end

template File.join(cache, '.aws/config') do
  sensitive true
  source 'aws-config.erb'
  variables(
    aws_access_key_id: delivery_secrets['access_key_id'],
    aws_secret_access_key: delivery_secrets['secret_access_key'],
    region: delivery_secrets['region']
  )
end

# TODO: support for other keys in qa-chef-server-cluster cookbook
# template File.join(path, 'data_bags/secrets/lob-user-key.json') do
#   sensitive true
#   source 'lob-user-key.json.erb'
#   variables(
#     private_key_path: ssh_private_key_path,
#     public_key_path:  ssh_public_key_path
#   )
# end

ruby_block 'DEBUG: Output Information about the Environment and System' do
  block do
    Chef::Log.info "USER: #{Mixlib::ShellOut.new('whoami').run_command.stdout}"
    Chef::Log.info "HOST: #{Mixlib::ShellOut.new('hostname -f').run_command.stdout}"
    Chef::Log.info "PATH: #{path}"
    Chef::Log.info Mixlib::ShellOut.new("ls -la #{path}").run_command.stdout
    Chef::Log.info "CACHE: #{cache}"
    Chef::Log.info Mixlib::ShellOut.new("ls -la #{cache}").run_command.stdout
    Chef::Log.info 'DISK SPACE:'
    Chef::Log.info Mixlib::ShellOut.new('df -h').run_command.stdout
  end
end

# rubocop:enable LineLength
