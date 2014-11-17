desc "Do it all (assumes chef-zero started)"
task :provision do
  sh('rm -f Gemfile.lock && bundle install && knife upload data_bags cookbooks && rm -f Berksfile.lock && berks install && berks upload && chef-client -c .chef/knife.rb -o my-cluster::provision')
end

desc "Clean it up (assumes chef-zero started)"
task :clean do
  sh('chef-client -c .chef/knife.rb -o my-cluster::clean')
end
