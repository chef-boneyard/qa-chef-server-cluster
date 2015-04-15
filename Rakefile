desc 'bundle and berks everything'
task :prep do
  sh("rm -f Gemfile.lock && bundle install && rm -rf Berksfile.lock berks-cookbooks && berks vendor")
end

desc 'clean vendor this cookbook'
task :update do
  sh("rm -rf berks-cookbooks/qa-chef-server-cluster && berks vendor")
end
task :default => [:update]

desc 'list all node ip addresses'
task :ip_search do
  sh("knife search -z '*:*' -i -a ipaddress")
end
