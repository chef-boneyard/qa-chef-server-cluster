current_dir = File.dirname(__FILE__)
log_level :info
key_name = 'qa-chef-server-cluster-default'
private_keys key_name => '/tmp/ssh/id_rsa'
public_keys  key_name => '/tmp/ssh/id_rsa.pub'
chef_repo_path File.join(current_dir, '..')
cookbook_path [ File.join(current_dir, '..', 'berks-cookbooks') ]
cache_path File.join(current_dir, 'local-mode-cache')
