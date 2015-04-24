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

#### Execution
`chef-client -z -o qa-chef-server-cluster::<topology>-<recipe>`

### Default Recipe
The `default` recipe is used to provision any topology and run the end-to-end recipe sequence:
 * install
 * upgrade (when enabled)
 * test (when enabled)
 * destroy (when enabled)
The controllable recipes are enabled or disabled by setting the appropriate attributes. See

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

|Description|Value|
|-----------|-----|
|dynamically resolve the latest stable release.|`latest-stable`|
|dynamically resolve the latest current build (or development version). |`latest-current`|
|download the current build for a specfic version by appending `+` |`1.2.3+`|
|download specfic stable release|`1.2.3`|
|download specfic development build by setting full version |`1.2.3+20150120085009`|

Review some common [config patterns](config-patterns.md)
