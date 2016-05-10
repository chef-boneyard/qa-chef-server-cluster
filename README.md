qa-chef-server-cluster cookbook
===============================

## DO NOT USE THIS FOR ANY PRODUCTION ENVIRONMENT!

This cookbook installs and upgrades Chef Server clusters as defined in [Chef Docs](http://docs.chef.io/server/). The recipes aim to follow the same procedures and commands in the prescribed sequences.  Since the docs are manual instructions, it should be understood that the recipes verify the published installation process versus an optimized automated solution.

This includes:
* Chef Server 12
* Enterprise Chef
* Open Source Chef
* Addons
* Standalone, Tier, HA topologies
* Ubuntu and RHEL platforms

See the [Provisioning Paths](PROVISIONING_PATHS.md) doc for additional details.

# Requirements
* AWS account and config
* chefdk

# Chef Zero
```
berks vendor

# default config
chef-client -z -o qa-chef-server-cluster::<recipe>

# attribute overrides
chef-client -z -j <attrs>.json -o qa-chef-server-cluster::<recipe>
```

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

`ha-cluster-trigger-failover`: Triggers an HA failover and verifies backend statuses. (Currently only fails over from initial bootstrap for Chef Server versions.)

`ha-enterprise-chef-ha-cluster`: Installs EC HA clusters. *NOTE: recommend using m3.large instance types for EC HA clusters.*

`ha-enterprise-chef-ha-cluster-upgrade`: Upgrades EC HA clusters

## Install and Upgrade Paths
The cookbook provisions two specific paths for installing new servers and upgrading servers rather than a single provisioning point of entry.  This was done for the following reasons:
* The Chef Docs define explicit install and upgrade paths, and it was important to maintain parity
* Allows installs to run again if an error is encountered without the risk of accidentally running upgrade procedures
* Allows devs to insert custom steps and different stages of the install/upgrade process like loading data, custom config, tools, etc.

## Provisioning Ids
The machine resources and other cluster-associated provisioning resources (ebs volumes, etc) will need to have unique names in order for a chef-repo to support multiple instances of topology clusters. Override the `['qa-chef-server-cluster']['provisioning-id']` attibute.  The default is `default`.

|topology|resource|name|
|--------|--------|----|
|Standalone|machine|`id-standalone`|
|Tier|machine|`id-tier-bootstrap-backend` `id-tier-frontend`|
|HA|machine|`id-ha-bootstrap-backend` `id-ha-secondary-backend` `id-tier-frontend`|
|HA|aws_ebs_volume, aws_eni|`id-ha`|

# License and Author
Author: Patrick Wright patrick@chef.io

Copyright (C) 2014-2016 Chef Software, Inc. legal@chef.io

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
