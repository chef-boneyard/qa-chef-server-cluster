require 'chef_spec_helper'

describe 'qa-chef-server-cluster::run-pedant' do
  context 'default options' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    it 'runs smoke tests' do
      expect(chef_run).to run_execute('chef-server-ctl test')
    end
  end

  context '--all option' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['qa-chef-server-cluster']['chef-server-ctl-test-options'] = '--all'
      end.converge(described_recipe)
    end

    it 'runs functional tests' do
      expect(chef_run).to run_execute('chef-server-ctl test --all')
    end
  end
end
