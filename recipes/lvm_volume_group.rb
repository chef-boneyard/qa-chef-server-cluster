include_recipe 'lvm'

# TODO report issue.  chef/data needs to be transposed in the docs
lvm_volume_group 'chef' do
  physical_volumes [ node['ha-config']['ebs_device'] ]

  logical_volume 'data' do
    size '85%VG'
    filesystem 'ext4'
    mount_point '/var/opt/opscode/drbd/data'
  end
end