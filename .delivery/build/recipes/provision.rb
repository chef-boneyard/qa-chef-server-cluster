#
# Cookbook Name:: build
# Recipe:: provision
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# we are ignoring the URD for now
return unless node['delivery']['change']['stage'] == 'acceptance'

# needed for aws cleanup below
include_recipe 'build::prepare_acceptance'

path = node['delivery']['workspace']['repo']

ruby_block 'Cleanup AWS instances' do
  block do
    Dir.chdir path
    begin
      nodes = JSON.parse(Mixlib::ShellOut.new("aws ec2 describe-instances --filters 'Name=tag-value,Values=qa-chef-server-cluster-delivery-builder' 'Name=tag-value,Values=#{node['delivery']['change']['stage']}'").run_command.stdout)
      nodes['Reservations'].each do |reservation|
        reservation['Instances'].each do |instance|
          if Time.now - Date.parse(instance['LaunchTime']).to_time > (24 * 60 * 60)
            Chef::Log.fatal "Terminating EC2 Instance #{instance['InstanceId']} which has been running since #{instance['LaunchTime']}"
            Mixlib::ShellOut.new("aws ec2 terminate-instances --instance-ids #{instance['InstanceId']}").run_command
          end
        end
      end
    rescue JSON::ParserError
      Chef::Log.fatal("aws ec2 describe-instances returned non-valid JSON (likely null).")
    end
  end
end

# Unless delivery-matrix::functional is also included, the parent job will
# report success even if the child job failed.
ENV['TERM'] = nil #hack hack hack for testing
include_recipe 'delivery-matrix::provision'
