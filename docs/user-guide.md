## End to End Cluster Validation
The following process applies to all topologies.

1. Create and install initial cluster
1. Upgrade existing cluster
1. Run pedant
1. Destroy cluster

### Main Cluster Recipes
Current supported topologies are `standalone-server` and `tier-cluster`.

`<topology>`: Creates and install the initial cluster

`<topology>-upgrade`: Upgrades an existing cluster

`<topology>-test`: Executes cluster tests (currently runs pedant)

`<topology>-destroy`: Destroys the cluster

### Execution
`chef-client -z -o qa-chef-server-cluster::<topology>-end-to-end`

## Configuration
### Data Bags
This project will use an insecure ssh key by default.  If your instances are public it is recommened to create a new ssh key data bag
and change the key name settings in .chef/knife.rb, chef-provisioner-key-name and bootstrap_options => key_name values.  This will be
configurable in a later version.
 * [SSH Keys](https://github.com/opscode-cookbooks/chef-server-cluster/#create-a-secrets-data-bag-and-populate-it-with-the-ssh-keys)

This project will also use a default set of private chef secrets. For testing purposes (and because we are behind a firewall) this is acceptable.
 * [Chef Server](https://github.com/opscode-cookbooks/chef-server-cluster/#create-a-private-chef-secrets-data-bag-item)

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
$ bin/generate-config OPTIONS
```

_Generates_
```json
{
  "qa-chef-server-cluster": {
    "enable-upgrade": false,
    "auto-destroy": true,
    "chef-server": {
      "install": {
        "version": "latest",
        "integration_builds": false
      },
      "upgrade": {
        "version": "latest",
        "integration_builds": true
      }
    },
    "manage": {
      "install": {
        "version": "",
        "integration_builds": false
      },
      "upgrade": {
        "version": "",
        "integration_builds": false
      }
    },
    "aws": {
      "machine_options": {
        "ssh_username": "ubuntu",
        "bootstrap_options": {
          "image_id": "ami-0f47053f"
        }
      }
    }
  }
}
```

### Version Resolution
This cookbook wraps the `oc-artifactory::omnibus_artifactory_artifact` resource to resolve and download packages from Artifactory repos. 
Versions are mainly categorized by two parameters: which version and integration build support.  These params are derived based on the version input.

|Description|Value|
|-----------|-----|
|dynamically resolve the latest stable release.|`latest-stable`|
|dynamically resolve the latest current build (or development version). |`latest-current`|
|download the current build for a specfic version by appending `+` |`1.2.3+`|
|download specfic stable release|`1.2.3`|
|download specfic development build by setting full version |`1.2.3+20150120085009`|


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

## Initiate Chef Run with Generated Config
Add the `--run-recipe` option and the chef-client will automatically run the recipe along with the generated json attributes.

```
$ generate-config --server-upgrade-source artifactory --enable-upgrade --run-recipe standalone-end-to-end -f
```
