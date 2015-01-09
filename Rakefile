desc 'bundle and berks on-demand'
task :prep do
  sh("rm -f Gemfile.lock && bundle install --deployment && rm -rf Berksfile.lock berks-cookbooks && berks vendor")
end
task :default => [:prep]
