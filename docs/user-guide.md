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
Note: All packages are downloaded from PackageCloud by default. Packages can also be download via URL and installed.
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
This cookbook wraps the `chef_server_ingredient` resource from the same named cookbook.  See the table below for details on how to choose the version for your needs.

|Description|Value|
|-----------|-----|
|dynamically resolve the latest chef/current package|`nil`|
|download specfic packages|`1.2.3` or `1.2.3+20150120085009` (the exact version from the chef repos|
|download from any URL bypassing PC resolution|any valid URL|

Review some common [config patterns](config-patterns.md)
