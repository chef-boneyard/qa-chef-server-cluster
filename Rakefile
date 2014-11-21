desc "Do it all"
task :provision do
  sh('rm -f Gemfile.lock && bundle install && rm -rf Berksfile.lock berks-cookbooks && berks vendor && chef-client -z -o qa-chef-server-cluster::standalone-cluster')
end

desc "Run chef-pedant"
task :provision_test do
  sh('chef-client -z -o qa-chef-server-cluster::standalone-test')
end

desc "Clean it up"
task :clean do
  sh('chef-client -z -o qa-chef-server-cluster::standalone-clean')
end

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts ">>>>> Kitchen gem not loaded, omitting tasks" unless ENV['CI']
end
