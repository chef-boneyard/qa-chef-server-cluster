desc "Do it all"
task :provision, [:topo] do |t, args|
  sh("chef-client -z -o qa-chef-server-cluster::#{args[:topo]}-cluster")
end

desc "Run chef-pedant"
task :pedant, [:topo] do |t, args|
  sh("chef-client -z -o qa-chef-server-cluster::#{args[:topo]}-test")
end

desc "Clean it up"
task :clean, [:topo] do |t, args|
  sh("chef-client -z -o qa-chef-server-cluster::#{args[:topo]}-clean")
end

desc 'bundle and berks on-demand'
task :prep do
  sh("rm -f Gemfile.lock && bundle install && rm -rf Berksfile.lock berks-cookbooks && berks vendor")
end

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts ">>>>> Kitchen gem not loaded, omitting tasks" unless ENV['CI']
end
