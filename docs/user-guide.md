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

`<topology>-end-to-end`: Helper recipe for running the main cluster recipes in sequence.

`ha-cluster-trigger-failover`: Triggers an HA failover and verifies backend statuses. (Currently only fails over from initial bootstrap)

#### Execution
`chef-client -z -o qa-chef-server-cluster::<topology>-<recipe>`

## Configuration
### Setting JSON attributes via chef-client

```
Note: All packages are downloaded from artifactory using the `omnibus_artifactory_artifact` resource.
```
## Generate JSON Attributes
`bin/generate-config --help`

Execute `bin/generate-config` to see the default output in attributes.json.

The file can be edited, but it is recommended to use the cli options to generate new files.  If a config option is not available please sumbit an issue.

The bin script can automatically run chef-client with the generated attributes using the `r, --run-recipe` option.

Or run `chef-client -z -j <attributes>.json -o qa-chef-server-cluster<::optional recipe>`

## Data Bags
This project will use an insecure ssh key by default.  If your instances are public it is recommened to create a new ssh key data bag
and change the key name settings in .chef/knife.rb, chef-provisioner-key-name and bootstrap_options => key_name values.  This will be
configurable in a later version.

### Version Resolution
This cookbook wraps the `omnibus_artifactory_artifact` resource from the `omnibus_artifactory_artifact` cookbook to resolve and download packages from Artifactory repos.
Versions are mainly categorized by two parameters: which version and integration build support.  These params are derived based on the version input.

Using the bin script options, the versions can be derived using the following options, and the attributes file will be generated with the correct paramters for the resource.

`bin/generate-config --help` to see updated descriptions.

|Description|Value|
|-----------|-----|
|install latest build from omnibus-stable-local|`latest-stable`|
|install latest build from omnibus-current-local|`latest-current`|
|install latest integration build for a specfic version by appending `+` (default: omnibus-current-local)|`1.2.3+`|
|install specfic build (default: omnibus-stable-local)|`1.2.3`|
|install specific build by setting full version (default: omnibus-current-local)|`1.2.3+20150120085009`|
|download from any URL | any valid URL |

Each default repo can be overridden by setting the `-repo` options for the related package.

Review some common [config patterns](config-patterns.md)
