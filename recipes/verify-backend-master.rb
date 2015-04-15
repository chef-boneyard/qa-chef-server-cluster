execute 'is master backend?' do
  command "[ `cat /var/opt/opscode/keepalived/current_cluster_status` = 'master' ]"
end