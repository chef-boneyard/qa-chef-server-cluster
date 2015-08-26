include_recipe 'lvm'

lvm_volume_group 'opscode' do
  physical_volumes [node['lvm_phyiscal_volume']]

  logical_volume 'drbd' do
    size '80%VG'
  end
end
