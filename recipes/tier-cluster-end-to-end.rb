#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: tier-end-to-end
#
# Author: Patrick Wright <patrick@chef.io>
# Copyright (C) 2014, Chef Software, Inc. <legal@getchef.com>
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

include_recipe 'qa-chef-server-cluster::tier-cluster'
include_recipe 'qa-chef-server-cluster::tier-cluster-upgrade' if node['qa-chef-server-cluster']['enable-upgrade']

#TODO (pwright)
ruby_block "race condition - boo" do
  block do
    sleep 60
  end
end

include_recipe 'qa-chef-server-cluster::tier-cluster-test'
include_recipe 'qa-chef-server-cluster::tier-cluster-destroy' if node['qa-chef-server-cluster']['auto-destroy']
