#
# Cookbook Name:: qa-chef-server-cluster
# Recipe:: debug
#
# Author: Ryan Hass <rhass@chef.io>
# Copyright (C) 2018, Chef Software, Inc. <legal@chef.io>
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


# This recipe is intended to help debug transient state issues.
# This will generate a list of files and directories to monitor and then
# output the events to the `/var/log/inotify.log` file.
#
# Warning from inotifywait man page:
#
# Warning:  If  you  use this option while watching the root directory of a large tree, it
# may take quite a while until all inotify watches are established, and events will not be
# received  in this time.  Also, since one inotify watch will be established per subdirec‐
# tory, it is possible that the maximum  amount  of  inotify  watches  per  user  will  be
# reached.    The   default   maximum   is  8192;  it  can  be  increased  by  writing  to
# /proc/sys/fs/inotify/max_user_watches.
#

# List of directories and files to watch. When monitoring for the creation of
# a directory or nested file, you must monitor an existing top level
# directory.
# Eg: `/opt/opscode` does not exist until after chef-server is installed;
#     instead you will have to monitor `/opt`.
node.default['qa-chef-server-cluster']['debug']['inotify'] = [
  '/var/opt',
]
node.default['qa-chef-server-cluster']['debug']['inotify_log'] = '/var/log/inotify.log'

package 'inotify-tools'

# Line delimited list of files and directories for inotify to monitor.
config = file '/etc/inotify.conf' do
  content node['qa-chef-server-cluster']['debug']['inotify'].join("\n")
  mode 0644
end

# Create an rc file since the target platform may not support systemd
# and most distributions have init file wrappers for systemd units.
file '/etc/init.d/inotify' do
  mode 0755
  content <<HEREDOC
#! /bin/sh
#
#### BEGIN INIT INFO
# Provides:          inotify
# Required-Start:    $local_fs $remote_fs
# Required-Stop:     0 6
# X-Start-Before:    rmnologin
# Default-Start:     2 3 4 5
# Short-Description: Watch files and directories for changes.
# Description:       Recursively monitor directories and files for
#                    changes and log the output.
### END INIT INFO
set -e

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LOGFILE=#{node['qa-chef-server-cluster']['debug']['inotify_log']}
PIDFILE=/var/run/inotify.pid
DAEMON=/usr/bin/inotifywait
DAEMON_ARGS="--recursive --monitor --fromfile #{config.path} --daemon --outfile $LOGFILE"

# Define LSB log_* functions.
. /lib/lsb/init-functions

do_start() {
  start-stop-daemon --start --exec $DAEMON -- $DAEMON_ARGS
}

do_stop() {
  start-stop-daemon --stop --quiet --exec $DAEMON
}

case "$1" in
  start)
        do_start
        ;;
  stop)
        do_stop
        ;;
  restart)
        do_stop
        do_start
        ;;
esac
HEREDOC
end

service 'inotify' do
  supports(start: true, stop: true, restart: true, reload: false)
  action [:enable, :start]
end
