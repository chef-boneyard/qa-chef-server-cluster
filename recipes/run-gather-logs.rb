execute 'chef-server-ctl gather-logs' do
  cwd Chef::Config[:file_cache_path]
  only_if 'test -f /opt/opscode/bin/gather-logs'
end

ruby_block 'find latest `chef-server-ctl gather-logs` archive' do
  block do
    latest_archive = Mixlib::ShellOut.new('ls -1t *.tbz2 | head -1',
      :cwd => Chef::Config[:file_cache_path])
    latest_archive.run_command

    node.default['latest_archive'] = latest_archive.stdout.strip!

    node['latest_archive'] =~ /ip-.*-UTC.tbz2/ ?
      Chef::Log.info("Found gather-logs archive #{node['latest_archive']}") :
      Chef::Log.error('No gather-logs archive found')
  end
end

link ::File.join(Chef::Config[:file_cache_path], 'latest-gather-logs.tbz2') do
  to lazy { node['latest_archive'] }
  only_if { node['latest_archive'] =~ /ip-.*-UTC.tbz2/ }
end
