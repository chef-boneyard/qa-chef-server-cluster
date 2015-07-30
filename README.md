qa-chef-server-cluster Cookbook
===============================
This cookbook installs and upgrades Chef Server clusters as defined in [Chef Docs](http://docs.chef.io/server/). This includes:
* Chef Server 12
* Enterprise Chef
* Open Source Chef
* Addons
* Standalone, Tier, HA topologies
* Ubuntu and RHEL platforms

See the [Provisioning Paths](PROVISIONING_PATHS.md) doc for additional details.

# Requirements
* AWS account and config
* For local usage a chef repo is recommended to vendor the cookbook
```ruby
# .chef/knife.rb
current_dir = File.dirname(__FILE__)
cookbook_path [ "#{current_dir}/../cookbooks", "#{current_dir}/../berks-cookbooks" ]
```
```ruby
# ./Berksfile
cookbook 'omnibus-artifactory-artifact', github: 'opscode-cookbooks/omnibus-artifactory-artifact'
cookbook 'qa-chef-server-cluster', github: 'chef/qa-chef-server-cluster'
```

# Attributes
The client run is driven by the configuration of the attributes.

Note that `install_method`, `url`, `version`, `repo`, and `integration_builds` are common options for downloading packages.  These are described in detail [below](#package-download-options).

## `qa-chef-server-cluster` attributes

Name | Description | Type | Default
----------|-------------|------|--------
`private-key` | private key that will be used to create the AWS key and the SSH keys for remote access | String | unsecured key in the attributes file.
`private-key` | public key that will be used for remote access | String | unsecured key in the attributes file.
`aws` | chef-provisioning-aws machine options | Hash | default settings have been configured for Chef's AWS account and VPN access. These default settings will not work if not connected to the VPN.
`provisioning-id` | value is prepended to the machine names so a chef repo can support multiple instances of clusters of the same topology. See [Provisioning Ids](#provisioning-ids)| String | `'default'`
`topology` | set to 'standalone', 'tier' or 'ha' when using the helper recipes like `install` | String | `nil`
`chef-server-ctl-test-options` | additional options to pass to the `ctl test` command | String | `''`
`download-logs` | downloads a generated `gather-logs` archive and stacktraces | Boolean | `false`

## `qa-chef-server-cluster chef-server` attributes

Name | Description | Type | Default
----------|-------------|------|--------
`api_fqdn` | Chef Server api_fqpn setting | String | `'api.chef.sh'`
`flavor` | used to identify when installing enterprise chef because of the version overlaps with osc. set to `'enterprise_chef'` when specifing an EC version | String |`'chef_server'`
`install_method` | | String | `'artifactory'`
`url` | | String | `nil`
`version` | | String, Symbol | `nil`
`repo` | | String | `'omnibus-stable-local'`
`integration_builds` | | Boolean | `false`

## `qa-chef-server-cluster opscode-manage` attributes

Name | Description | Type | Default
----------|-------------|------|--------
`install_method` | | String | `'artifactory'`
`url` | | String | `nil`
`version` | | String, Symbol | `nil`
`repo` | | String | `'omnibus-stable-local'`
`integration_builds` | | Boolean | `false`

## `qa-chef-server-cluster chef-ha` attributes

Name | Description | Type | Default
----------|-------------|------|--------
`install_method` | | String | `'artifactory'`
`url` | | String | `nil`
`version` | | String, Symbol | `'1.0.0'`
`repo` | | String | `'omnibus-stable-local'`
`integration_builds` | | Boolean | `false`

# Package Download Options
The `install_method` value modifies the way `version`, `repo`, and `integration_builds` function.  
When the `url` attribute is set the `install_method` and related options are ignored entirely.  

`install_method`: 'artifactory', 'packagecloud', 'chef-server-ctl'

### artifactory
Uses [omnibus-artifactory-artifact](https://github.com/opscode-cookbooks/omnibus-artifactory-artifact) cookbook to resolve packages from `artifactory.chef.co`.

Name | Description | Type | Default
----------|-------------|------|--------
`version` | See omnibus-artifactory-artifact for available options | String, Symbol | `nil`
`repo` | This attribute only applies to this install method | String | `'omnibus-stable-local'`
`integration_builds` | This attribute only applies to this install method | Boolean | `false`

### packagecloud
Name | Description | Type | Default
----------|-------------|------|--------
`version` | When using this method the node will be configured with the chef/stable and chef/current repos.  Using the 'latest' option will download the most recent dev version in the current repo. | String, Symbol | `nil`

### chef-server-ctl
This only works for installing addons on Chef Server 12.  This will execute `chef-server-ctl install addon_name` for the configured package.

# Main Cluster Recipes
Current supported topologies are `standalone-server`, `tier-cluster` and `ha-cluster`.

`<topology>`: Creates and install the initial cluster

`<topology>-upgrade`: Upgrades an existing cluster

`<topology>-generate-test-data`: Loads data using [Chef Server Data Generator](https://github.com/chef/chef-server-data-generator)

`<topology>-test`: Executes cluster tests (currently runs pedant)

`<topology>-destroy`: Destroys the cluster

## Other Recipes
`<topology>-logs`: Runs `chef-server-ctl gather-logs`, and downloads the archives and any error logs (chef-stacktrace.out)
Note: the install and upgrade provision recipes download logs during execution.  This is intended to be used on-demand.

`ha-cluster-trigger-failover`: Triggers an HA failover and verifies backend statuses. (Currently only fails over from initial bootstrap)

`install`: Will run the appropriate install recipes when the `topology` attribute is configured.

`upgrade`: Will run the appropriate upgrade recipes when the `topology` attribute is configured.

`load-data`: Will run the appropriate data loading recipes when the `topology` attribute is configured.

`destroy`: Will run the appropriate destroy recipes when the `topology` attribute is configured.


## Provisioning Ids
The machine resources and other cluster-associated provisioning resources (ebs volumes, etc) will need to have unique names in order for a chef-repo to support multiple instances of topology clusters. Override the `['qa-chef-server-cluster']['provisioning-id']` attibute.  The default is `default`.

|topology|resource|name|
|--------|--------|----|
|Standalone|machine|`id-standalone`|
|Tier|machine|`id-tier-bootstrap-backend` `id-tier-frontend`|
|HA|machine|`id-ha-bootstrap-backend` `id-ha-secondary-backend` `id-tier-frontend`|
|HA|aws_ebs_volume, aws_eni|`id-ha`|

## Generating Environments with qa-csc-config
Creating envionment files manually is a chore.  `qa-chef-server-cluster` has a counterpart utility named `qa-csc-config`. You can learn all about `qa-csc-config` by seeing the [README](https://github.com/chef/qa-csc-config)

# License and Author
Author: Patrick Wright patrick@chef.io.com

Copyright (C) 2014-2015 Chef Software, Inc. legal@chef.io

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
