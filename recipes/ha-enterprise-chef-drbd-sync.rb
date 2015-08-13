# UBUNTU 12.04 ONLY UNTIL REQUIRED
execute 'drbdadm -- --overwrite-data-of-peer primary pc0'
# TODO add guard

execute 'mkfs.ext4 /dev/drbd0' do
  not_if 'mount -l | grep /dev/drbd0'
end

DRBD_DIR = '/var/opt/opscode/drbd'
DRBD_ETC_DIR =  ::File.join(DRBD_DIR, 'etc')
DRBD_DATA_DIR = ::File.join(DRBD_DIR, 'data')

[ DRBD_DIR, DRBD_ETC_DIR, DRBD_DATA_DIR ].each do |dir|
  directory dir do
    recursive true
    mode '0755'
  end
end

execute 'mount /dev/drbd0 /var/opt/opscode/drbd/data' do
  not_if 'mount -l | grep /dev/drbd0'
end

execute 'drbdadm disk-options --resync-rate=1100M pc0'

# WAIT FOR SYNC COMPLETE
execute 'until drbdadm dstate pc0 | grep "UpToDate/UpToDate"; do sleep 10 ; done'
