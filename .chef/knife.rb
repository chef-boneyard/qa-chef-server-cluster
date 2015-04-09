current_dir = File.dirname(__FILE__)

repo = File.join(current_dir, '..')
chef_repo_path repo

key_name = 'qa-chef-server-cluster-default'
private_keys key_name => File.join(current_dir, 'keys', 'id_rsa')
public_keys  key_name => File.join(current_dir, 'keys', 'id_rsa.pub')

cookbook_path [ File.join(repo, 'berks-cookbooks') ]

data_bag_path [ File.join(repo, 'data_bags'),
                File.join(current_dir, 'data_bags') ]

node_path [ File.join(current_dir, 'nodes') ]

cache_path File.join(current_dir, 'local-mode-cache')

log_level :info
