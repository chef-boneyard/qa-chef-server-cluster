#
# Copyright:: Copyright (c) 2015 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'delivery-truck'

delivery_github 'opscode-cookbooks/omnibus-artifactory-artifact' do
  deploy_key secrets['github']
  branch node['delivery']['change']['pipeline']
  remote_url "git@github.com:#{github_repo}.git"
  repo_path node['delivery']['workspace']['repo']
  cache_path node['delivery']['workspace']['cache']
  action :clone
end

chef_gem 'mixlib-versioning' do
  compile_time false
  action :install
end

