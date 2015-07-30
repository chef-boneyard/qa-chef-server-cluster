upgrade_from_server = upgrade_from_server_flavor(installed_chef_server_packages)

execute "#{upgrade_from_server.ctl_exec} stop keepalived"
