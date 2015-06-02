directory '/etc/opscode' do
  mode 0755
  recursive true
end

include_recipe 'apt'

# TODO add force-apt-update attr and cli option
execute 'apt-get update' # c'mon apt cookbook, do your job!

include_recipe 'build-essential'

chef_server_ingredient 'chef-server-core' do
  action :nothing
end

chef_server_ingredient 'opscode-manage' do
  action :nothing
end

service 'iptables' do
  action [ :disable, :stop ]
  only_if { platform_family?('rhel') }
end

# rhel 5 does not support ssl protocol SNI
# for simplification, all rhel version import the key locally
gpg_key = ::File.join(Chef::Config[:file_cache_path], 'packages-chef-io-public.key')
remote_file gpg_key do
  source "https://downloads.chef.io/packages-chef-io-public.key"
  only_if { platform_family?('rhel') }
end

execute 'import keys for rhel' do
  command "rpm --import #{gpg_key}"
  only_if { platform_family?('rhel') }
end

packagecloud_repo 'chef/stable' do
  type value_for_platform_family(debian: 'deb', rhel: 'rpm')
end

packagecloud_repo 'chef/current' do
  type value_for_platform_family(debian: 'deb', rhel: 'rpm')
end
