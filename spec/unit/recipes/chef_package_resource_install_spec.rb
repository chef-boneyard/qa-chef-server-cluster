require 'chef_spec_helper'

describe 'chef_package_resource::install' do
  context 'install chef-server' do
    context 'no version is specified' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(step_into: ['chef_package']).converge(described_recipe)
      end

      it 'does not install the package' do
        expect(chef_run).not_to install_chef_ingredient('manage')
      end
    end

    context 'using url' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(
          step_into: ['chef_package']
        ).converge(described_recipe)
      end

      it 'sets up the resource' do
        expect(chef_run).to install_chef_package('chef-server-url').with(
          product_name: 'chef-server',
          package_url: 'https://mydomain.com/package.ext'
        )
      end

      it 'calls remote_file' do
        expect(chef_run).to create_remote_file('/var/chef/cache/package.ext').with(
          source: 'https://mydomain.com/package.ext'
        )
      end

      it 'installs package' do
        expect(chef_run).to install_chef_ingredient('chef-server').with(
          package_source: "#{::File.join(Chef::Config.file_cache_path, ::File.basename('/var/chef/cache/package.ext'))}"
        )
      end
    end
  end
end
