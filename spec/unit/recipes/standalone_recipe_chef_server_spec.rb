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

    context 'when install_method is artifactory' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(step_into: ['chef_package']) do |node|
          node.set['qa-chef-server-cluster']['chef-server']['flavor'] = 'chef_server'
          node.set['qa-chef-server-cluster']['chef-server']['install_method'] = 'artifactory'
          node.set['qa-chef-server-cluster']['chef-server']['version'] = :latest
        end.converge(described_recipe)
      end

      it 'sets up resource' do
        expect(chef_run).to install_chef_package('chef-server').with(
          package_url: nil,
          install_method: 'artifactory',
          version: :latest,
          integration_builds: false,
          repository: 'omnibus-stable-local',
          reconfigure: true
        )
      end

      it 'uses artifactory' do
        expect(chef_run).to create_omnibus_artifactory_artifact('chef-server')
      end
    end

    context 'when install_method is artifactory private-chef' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(step_into: ['chef_package']) do |node|
          node.set['qa-chef-server-cluster']['chef-server']['flavor'] = 'enterprise_chef'
          node.set['qa-chef-server-cluster']['chef-server']['install_method'] = 'artifactory'
          node.set['qa-chef-server-cluster']['chef-server']['version'] = :latest
        end.converge(described_recipe)
      end

      it 'sets up resource' do
        expect(chef_run).to install_chef_package('private-chef').with(
          package_url: nil,
          install_method: 'artifactory',
          version: :latest,
          integration_builds: false,
          repository: 'omnibus-stable-local',
          reconfigure: true
        )
      end

      it 'uses artifactory' do
        expect(chef_run).to create_omnibus_artifactory_artifact('private-chef')
      end
    end

    context 'when install_method is packagecloud' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(step_into: ['chef_package']) do |node|
          node.set['qa-chef-server-cluster']['chef-server']['flavor'] = 'chef_server'
          node.set['qa-chef-server-cluster']['chef-server']['install_method'] = 'packagecloud'
          node.set['qa-chef-server-cluster']['chef-server']['version'] = :latest
        end.converge(described_recipe)
      end

      it 'sets up packagecloud' do
        expect(chef_run).to create_packagecloud_repo('chef/stable')
      end

      it 'uses chef_ingredient' do
        expect(chef_run).to install_chef_ingredient('chef-server')
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

      it 'uses chef_ingredient' do
        expect(chef_run).to install_chef_ingredient('chef-server').with(
          package_source: "#{::File.join(Chef::Config.file_cache_path, ::File.basename('/var/chef/cache/package.ext'))}"
        )
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
