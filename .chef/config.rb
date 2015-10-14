current_dir = File.dirname(__FILE__)

cookbook_path [ "#{current_dir}/../berks-cookbooks" ]

chef_repo_path File.expand_path(File.join(current_dir))
