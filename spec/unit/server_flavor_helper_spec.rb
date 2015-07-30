# require 'spec_helper'

# describe QaChefServerCluster::ServerFlavorHelper do
#   describe '.open_source_chef' do
#     subject(:open_source_chef) { described_class.open_source_chef }

#     it 'is a ChefServer' do
#       is_expected.to be_a ChefServer
#     end
#     it 'returns ctl_exec' do
#       expect(open_source_chef.ctl_exec).to eq 'chef-server-ctl'
#     end
#     it 'returns config_file' do
#       expect(open_source_chef.config_file).to eq 'chef-server.rb'
#     end
#     it 'returns config_path' do
#       expect(open_source_chef.config_path).to eq '/etc/chef-server/'
#     end
#     it 'returns package_name' do
#       expect(open_source_chef.package_name).to eq 'chef-server'
#     end
#   end

#   describe '.chef_server' do
#     subject(:chef_server) { described_class.chef_server }

#     it 'is a ChefServer' do
#       is_expected.to be_a ChefServer
#     end
#     it 'returns ctl_exec' do
#       expect(chef_server.ctl_exec).to eq 'chef-server-ctl'
#     end
#     it 'returns config_file' do
#       expect(chef_server.config_file).to eq 'chef-server.rb'
#     end
#     it 'returns config_path' do
#       expect(chef_server.config_path).to eq '/etc/opscode/'
#     end
#     it 'returns package_name' do
#       expect(chef_server.package_name).to eq 'chef-server'
#     end
#   end

#   describe '.enterprise_chef' do
#     subject(:enterprise_chef) { described_class.enterprise_chef }

#     it 'is a ChefServer' do
#       is_expected.to be_a ChefServer
#     end
#     it 'returns ctl_exec' do
#       expect(enterprise_chef.ctl_exec).to eq 'private-chef-ctl'
#     end
#     it 'returns config_file' do
#       expect(enterprise_chef.config_file).to eq 'private-chef.rb'
#     end
#     it 'returns config_path' do
#       expect(enterprise_chef.config_path).to eq '/etc/opscode/'
#     end
#     it 'returns package_name' do
#       expect(enterprise_chef.package_name).to eq 'private-chef'
#     end
#   end
# end
