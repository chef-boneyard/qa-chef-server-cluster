## End to End Cluster Validation
The following process applies to all topologies.

1. Create and install initial cluster
1. Upgrade existing cluster
1. Run pedant
1. Destroy cluster

### Main Cluster Recipes
Current supported topologies are `standalone` and `tier`.

`<topology>-cluster`: Creates and install the initial cluster

`<topology>-upgrade`: Upgrades an existing cluster

`<topology>-test`: Executes cluster tests (currently runs pedant)

`<topology>-destroy`: Destroys the cluster

`<topology>-end-to-end`: Runs standalone recipes in sequence

### Execution
`chef-client -z -o qa-chef-server-cluster::<topology>-end-to-end`

## Configuration
### Data Bags
1. [SSH Keys](https://github.com/opscode-cookbooks/chef-server-cluster/#create-a-secrets-data-bag-and-populate-it-with-the-ssh-keys)
1. [Chef Server](https://github.com/opscode-cookbooks/chef-server-cluster/#create-a-private-chef-secrets-data-bag-item)

### Setting JSON attributes via chef-client

#### Package Cloud chef/stable
* Default execution will install the latest chef/stable packages from packagecloud. 
* The package versions can also be specified by overridding the node attributes.
```json 
{ "qa-chef-server-cluster": { "chef-server-core": { "version": "VERSION" } } }
```
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

Command:
```bash
$ bin/generate-config -j my-attrs.json  \
-f \
--server-upgrade-source 'https://jenkins.ci/package.deb' \
--enable-upgrade
```

Generates:
```json
{
  "qa-chef-server-cluster": {
    "chef-server-core": {
      "upgrade-source": "https://jenkins.ci/package.deb"
    },
    "opscode-manage": {
    },
    "enable-upgrade": true
  }
}
```

Execution:
```
chef-client -z -j my-attrs.json -o qa-chef-server-cluster::<TOPOLOGY>-end-to-end
```

1. installs a standalone cluster using the latest stable server and manage packages from packagecloud
1. enable the upgrade process
1. upgrade chef server with the package downloaed from the source link
1. run pedant
1. destroy cluster

Review some common [config patterns](config-patterns.md)

## Cookbook Attributes
See attributes/default.rb for default values.
Here's how this cookbook's attributes (node['qa-chef-server-cluster']) work and/or affect behavior.

`chef-provisioner-key-name`: Set the ec2 key name

`aws['machine_options']`: Configure the provisioner machine options

`[chef-server-core]`: Hash to configure which chef server packages to install or upgrade

`chef-server-core['source']`: Directly download link to source package

`chef-server-core['version']`: Specify version to download from package cloud chef/stable

`chef-server-core['upgrade-source']`: Directly download link to source package when performing an upgrade

`chef-server-core['upgrade-version']`: Specify version to download from package cloud chef/stable when performing an upgrade

`[opscode-manage]`: Hash to configure which manage packages to install or upgrade. 
This hash follows the same `source`, `upgrade-source`, `version`, and `upgrade-version` as chef-server-core.

`enable-upgrade`: Set to true to enable the upgrade process.

`auto-destroy`: Set to false to disable the cluster tear down at the end of a successfull pedant run.

# IGNORE BELOW THIS LINE


CI Process Flow
## New Install from Dev build (standalone)
*cs12 build / test pipeline successful (jenkins exports links to build artifact - assume we have access to this)*

start upgrade test pipeline

1. install new cluster
* pre generated data bags
* update url location (data bag value)
* pedant test all




### GA install to Dev build upgrade (standalone)

*cs12 build / test pipeline successful (jenkins exports links to build artifact - assume we have access to this)*

start upgrade test pipeline

1. install new cluster
* pre generated data bags
* cs12 stable packagecloud
* quick pedant test
2. upgrade cluster
* requires change to data bag (MANUAL PART)
* download from cs12 dev from jenkins
* run upgrade recipe
* pedant test all

upgrade test pipeline complete
 
