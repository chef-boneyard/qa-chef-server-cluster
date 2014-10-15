config_dir = File.dirname(__FILE__)
chef_server_url 'http://localhost:7799'
log_level :info
node_name        'metal-provisioner'
cookbook_path [File.join(config_dir, '..', 'cookbooks')]
key_name = 'wrightp-metal-provisioner' # CHANGEME
private_keys key_name => '/tmp/ssh/id_rsa'
public_keys  key_name => '/tmp/ssh/id_rsa.pub'
client_key '/Users/patrickwright/test/id_rsa' # CHANGEME
