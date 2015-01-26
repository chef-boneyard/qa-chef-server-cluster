directory '/etc/opscode' do
  mode 0755
  recursive true
end

include_recipe 'apt::default'
include_recipe 'build-essential::default'
