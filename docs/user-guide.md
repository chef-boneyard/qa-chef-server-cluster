## End to End Cluster Validation
The following process applies to all topologies.

1. Create and install initial cluster
1. Upgrade existing cluster
1. Run pedant
1. Destroy cluster

### Main Cluster Recipes
Current supported topologies are `standalone` and `tier`.

`<topology>-cluster`: Creates and install the initial cluster

`<topology>-cluster-upgrade`: Upgrades an existing cluster

`<topology>-test`: Executes cluster tests (currently runs pedant)

`<topology>-destroy`: Destroys the cluster

`<topology>-end-to-end`: Runs recipes in sequence (accounting for the configuration)

### Execution
`chef-client -z -o qa-chef-server-cluster::<topology>-end-to-end`

## Configuration
### Data Bags
1. [SSH Keys](https://github.com/opscode-cookbooks/chef-server-cluster/#create-a-secrets-data-bag-and-populate-it-with-the-ssh-keys)
1. [Chef Server](https://github.com/opscode-cookbooks/chef-server-cluster/#create-a-private-chef-secrets-data-bag-item)

### Setting JSON attributes via chef-client

#### Package Cloud chef/stable
* Default execution will install the latest chef/stable packages from packagecloud. 

#### Remote Location
* Specify a download location other than packagecloud (like jenkins)
```json 
{ "qa-chef-server-cluster": { "chef-server-core": { "source": "http://domain.com/file.package" } } }
```
#### Upgrade
```json
  "qa-chef-server-cluster": {
    "enable-upgrade": true
  }
```
Defaults to false. The upgrade will be skipped when false.
#### Destroy
```json
  "qa-chef-server-cluster": {
    "auto-destroy": false
  }
```
Defaults to true. The cluster will be destroyed upon a successfully pedant run.

## Generate JSON Attributes
`bin/generate-config --help`

_Command_
```bash
$ bin/generate-config -j my-attrs.json  \
-f \
--server-upgrade-source 'https://domain.ci/package.deb' \
--enable-upgrade
```

_Setting `--server-[install|upgrade]-source artifactory` will retrieve the latest integration build from artifactory._

_Generates_
```json
{
  "qa-chef-server-cluster": {
    "chef-server-core": {
      "upgrade-source": "https://domain.ci/package.deb"
    },
    "opscode-manage": {
    },
    "enable-upgrade": true
  }
}
```

_Execute_
```
chef-client -z -j my-attrs.json -o qa-chef-server-cluster::<topology>-end-to-end
```

1. installs a standalone cluster using the latest stable server and manage packages from packagecloud
1. enable the upgrade process
1. upgrade chef server with the package downloaed from the source link
1. run pedant
1. destroy cluster

Review some common [config patterns](config-patterns.md)

### One Shot, One Kill
Add the `--run-recipe` option and the chef-client will automatically run with the generated json attributes

```
$ generate-config --server-upgrade-source artifactory --enable-upgrade --run-recipe standalone-end-to-end -f
```

## Cookbook Attributes
See attributes/default.rb for default values.
Here's how this cookbook's attributes (node['qa-chef-server-cluster']) work and/or affect behavior.

`chef-provisioner-key-name`: Set the ec2 key name

`aws['machine_options']`: Configure the provisioner machine options

`[chef-server-core]`: Hash to configure which chef server packages to install or upgrade

`chef-server-core['source']`: Directly download link to source package

`chef-server-core['upgrade-source']`: Directly download link to source package when performing an upgrade

`[opscode-manage]`: Hash to configure which manage packages to install or upgrade. 
This hash follows the same `source`, `upgrade-source` as chef-server-core.

`enable-upgrade`: Set to true to enable the upgrade process.

`auto-destroy`: Set to false to disable the cluster tear down at the end of a successfull pedant run.

# Credit
This wrapper cookbook deserves the recognition of Paul Mooring <paul@chef.io> and 
Joshua Timberman <joshua@chef.io> for their great work on the chef-server-cluster and chef-server-ingredient cookbooks.

# License and Author
Author: Patrick Wright patrick@chef.io.com

Copyright (C) 2014 Chef Software, Inc. legal@chef.io

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
