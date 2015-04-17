execute 'is backup backend?' do
  command "[ `cat /var/opt/opscode/keepalived/current_cluster_status` = 'backup' ]"
end
