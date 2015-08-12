# UBUNTU 12.04 ONLY UNTIL REQUIRED
execute 'drbdadm -- --overwrite-data-of-peer primary pc0'
# TODO add guard

execute 'mkfs.ext4 /dev/drbd0' do
  not_if 'mount -l | grep /dev/drbd0'
end

directory '/var/opt/opscode/drbd/data' do
  recursive true
end

execute 'mount /dev/drbd0 /var/opt/opscode/drbd/data' do
  not_if 'mount -l | grep /dev/drbd0'
  notifies :run, 'execute[drbdadm disk-options --resync-rate=1100M pc0]', :immediately
end

execute 'drbdadm disk-options --resync-rate=1100M pc0' do
  action :nothing
end

# WAIT FOR SYNC COMPLETE
execute 'until drbdadm dstate pc0 | grep "UpToDate/UpToDate"; do sleep 10 ; done'
