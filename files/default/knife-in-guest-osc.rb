current_dir = File.dirname(__FILE__)
chef_server_url 'https://127.0.0.1'
node_name 'admin'
client_key '/etc/chef-server/admin.pem'
ssl_verify_mode :verify_none
cookbook_path ["#{current_dir}/../cookbooks"]
