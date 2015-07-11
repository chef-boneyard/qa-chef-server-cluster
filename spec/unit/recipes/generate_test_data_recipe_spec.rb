require 'chef_spec_helper'

describe 'qa-chef-server-cluster::generate-test-data' do
  context 'when chef server' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['qa-chef-server-cluster']['chef-server']['flavor'] = 'chef_server'
        node.set['qa-chef-server-cluster']['chef-server']['version'] = :latest
      end.converge(described_recipe)
    end

    it 'creates chef server directory' do
      expect(chef_run).to create_directory('/etc/opscode/')
    end

    it 'does not append existing private-chef config to current config' do
      expect(chef_run).not_to run_execute("sudo cat private-chef.rb >> /etc/opscode/chef-server.rb")
    end

    it 'creates the knife config' do
      expect(chef_run).to create_cookbook_file('/tmp/chef-server-data-generator/.chef/knife-in-guest.rb').with(
        source: 'knife-in-guest-ec.rb'
      )
    end

    it 'runs setup script' do
      expect(chef_run).to run_execute('sudo ./setup-ec.sh') 
    end
  end

  context 'when open source chef' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['qa-chef-server-cluster']['chef-server']['flavor'] = 'chef_server'
        node.set['qa-chef-server-cluster']['chef-server']['version'] = '11.0.0'
      end.converge(described_recipe)
    end

    it 'creates chef server directory' do
      expect(chef_run).to create_directory('/etc/chef-server/')
    end

    it 'does not append existing private-chef config to current config' do
      expect(chef_run).not_to run_execute("sudo cat private-chef.rb >> /etc/chef-server/chef-server.rb")
    end

    it 'creates the knife config' do
      expect(chef_run).to create_cookbook_file('/tmp/chef-server-data-generator/.chef/knife-in-guest.rb').with(
        source: 'knife-in-guest-osc.rb'
      )
    end

    it 'runs setup script' do
      expect(chef_run).to run_execute('sudo ./setup-osc.sh') 
    end
  end

  context 'when enterprise chef' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['qa-chef-server-cluster']['chef-server']['flavor'] = 'enterprise_chef'
      end.converge(described_recipe)
    end

    it 'creates chef server directory' do
      expect(chef_run).to create_directory('/etc/opscode/')
    end

    it 'appends existing private-chef config to current config' do
      expect(chef_run).to run_execute("sudo cat private-chef.rb >> /etc/opscode/private-chef.rb")
    end
   
    it 'creates the knife config' do
      expect(chef_run).to create_cookbook_file('/tmp/chef-server-data-generator/.chef/knife-in-guest.rb').with(
        source: 'knife-in-guest-ec.rb'
      )
    end

    it 'runs setup script' do
      expect(chef_run).to run_execute('sudo ./setup-ec.sh') 
    end
  end
end
