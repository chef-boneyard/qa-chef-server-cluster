upgrade_from_server = upgrade_from_server_flavor(installed_chef_server_packages)

execute "#{current_server.ctl_exec} start"
