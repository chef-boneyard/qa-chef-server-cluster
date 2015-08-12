include_recipe 'lvm'

lvm_volume_group 'opscode' do
  physical_volumes [ node['ha-config']['ebs_device'] ]

  logical_volume 'drbd' do
    size '80%VG'
  end
end
