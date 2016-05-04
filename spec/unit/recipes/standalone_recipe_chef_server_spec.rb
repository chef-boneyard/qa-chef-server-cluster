require 'chef_spec_helper'

describe 'qa-chef-server-cluster::standalone' do
  describe 'when flavor is chef server' do
    context 'when :lastest version' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.set['qa-chef-server-cluster']['chef-server']['flavor'] = 'chef_server'
        end.converge(described_recipe)
      end

      it 'creates chef server directory' do
        expect(chef_run).to create_directory('/etc/opscode/')
      end
    end

    context 'when 11.x version' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.set['qa-chef-server-cluster']['chef-server']['flavor'] = 'open_source_chef'
        end.converge(described_recipe)
      end

      it 'creates chef server directory' do
        expect(chef_run).to create_directory('/etc/chef-server/')
      end
    end

    context 'when url is set' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(step_into: ['chef_package']) do |node|
          node.set['qa-chef-server-cluster']['chef-server']['flavor'] = 'chef_server'
          node.set['qa-chef-server-cluster']['chef-server']['url'] = 'http://myurl/package.ext'
        end.converge(described_recipe)
      end

      it 'uses url' do
        expect(chef_run).to create_remote_file('/var/chef/cache/package.ext')
      end
    end

    context 'when upgrading from enterprise_chef' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(step_into: ['chef_package']) do |node|
          node.set['qa-chef-server-cluster']['chef-server']['flavor'] = 'chef_server'
          node.set['qa-chef-server-cluster']['chefspec']['upgrade_flavor'] = 'private-chef'
        end.converge('qa-chef-server-cluster::standalone-upgrade')
      end

      it 'detects enterprise_chef' do
        expect(chef_run).to run_execute('private-chef-ctl stop')
      end
    end

    context 'when upgrading from open_source_chef' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(step_into: ['chef_package']) do |node|
          node.set['qa-chef-server-cluster']['chef-server']['flavor'] = 'chef_server'
          node.set['qa-chef-server-cluster']['chefspec']['upgrade_flavor'] = 'chef-server'
        end.converge('qa-chef-server-cluster::standalone-upgrade')
      end

      it 'detects open_source_chef' do
        expect(chef_run).to run_execute('chef-server-ctl stop')
      end
    end

    context 'when upgrading from chef_server' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(step_into: ['chef_package']) do |node|
          node.set['qa-chef-server-cluster']['chef-server']['flavor'] = 'chef_server'
          node.set['qa-chef-server-cluster']['chefspec']['upgrade_flavor'] = 'chef-server-core'
        end.converge('qa-chef-server-cluster::standalone-upgrade')
      end

      it 'detects chef_server' do
        expect(chef_run).to run_execute('chef-server-ctl stop')
      end
    end
  end
end
