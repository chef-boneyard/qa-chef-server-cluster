Quality Advocacy Chef Server Cluster
========
Recipes for installing, upgrading and testing Chef Server 12 topologies.  This cookbook is not designed as an idempotent
tool for managing chef servers. It is designed to accept package versions and run the install instructions
as documented for each configuration scenario from [Install Chef Server 12](https://docs.chef.io/install_server.html) and
[Upgrade Chef Server 12](https://docs.chef.io/upgrade_server.html).

# Requirements
* aws config

# Usage
1. Run `rake prep` to install dependencies
1. Run `chef-client -z -o qa-chef-server-cluster` for out of the box functionality

## End to End Cluster Validation
The following process applies to all topologies.

1. Create and install initial cluster
1. Upgrade existing cluster
1. Run pedant
1. Destroy cluster

### Main Cluster Recipes
Current supported topologies are `standalone-server`, `tier-cluster` and `ha-cluster`.

`<topology>`: Creates and install the initial cluster

`<topology>-upgrade`: Upgrades an existing cluster

`<topology>-test`: Executes cluster tests (currently runs pedant)

`<topology>-destroy`: Destroys the cluster

### Other Cluster Recipes
`<topology>-logs`: Runs `chef-server-ctl gather-logs`, and downloads the archives and any error logs (chef-stacktrace.out)
Note: the install and upgrade provision recipes download logs during execution.  This is intended to be used on-demand.

`ha-cluster-trigger-failover`: Triggers an HA failover and verifies backend statuses. (Currently only fails over from initial bootstrap)

## Version Resolution
This cookbook wraps the `omnibus_artifactory_artifact` resource from the `omnibus_artifactory_artifact` cookbook to resolve and download packages from Artifactory repos.

## Skipping Installation and Upgrade Steps
Other than the initial installation of chef-server-core, all other steps are configurable to be skipped during the provision.  This does include upgrading chef-server-core in the case where you would only want to upgrade opscode-manage.  This is achieved by setting the `['skip']` attributes to `true`.

## Execution
The concept of execution is to run one of the core recipes per chef-client run. This allows the author to inject their own tests or data generation tools whenever it's necessary. The install recipe will need an environment associated to the nodes.

For example:  
`chef-client -z -E my_test -o qa-chef-server-cluster::standalone-server`  

If the `my_test` environment is to be updated, the envionment attributes must be updated with the new configuration before running.  

*Update environment here (perhaps using qa-csc-config)*  

Then upgrade the server  
`chef-client -z -E my_test -o qa-chef-server-cluster::standalone-server-upgrade`

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
