#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: run-gather-logs
#
# Author: Patrick Wright <patrick@chef.io>
# Copyright (C) 2015, Chef Software, Inc. <legal@getchef.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
gather_logs_cmd = "#{current_server.ctl_exec} gather-logs"

execute gather_logs_cmd do
  cwd Chef::Config[:file_cache_path]
  only_if 'test -f /opt/opscode/bin/gather-logs'
end

ruby_block 'find latest gather-logs archive' do
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
