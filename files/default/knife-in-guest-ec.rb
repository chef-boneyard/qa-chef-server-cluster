current_dir = File.dirname(__FILE__)
# chef_server_url 'https://127.0.0.1'
chef_server_url 'https://api.chef.sh' # Set in /etc/hosts on frontends
node_name 'pivotal'
client_key '/etc/opscode/pivotal.pem'
ssl_verify_mode :verify_none
cookbook_path ["#{current_dir}/../cookbooks"]
