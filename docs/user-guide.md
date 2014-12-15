## Data Bags
1. [SSH Keys](https://github.com/opscode-cookbooks/chef-server-cluster/#create-a-secrets-data-bag-and-populate-it-with-the-ssh-keys)
1. [Chef Server](https://github.com/opscode-cookbooks/chef-server-cluster/#create-a-private-chef-secrets-data-bag-item)

## Standalone Cluster
### End to End
1. Create and install initial cluster
1. Upgrade existing cluster
1. Run pedant
1. Destroy cluster

### Configuration
Setting JSON attributes via chef-client

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
#### Example
This blah
```json
{
  "qa-chef-server-cluster": {
    "enable-upgrade": true
    BLAH BLAH
  }
}
```

### Recipe Components
`standalone-cluster`: Creates and install the initial cluster

`standalone-upgrade`: Upgrades an existing cluster

`standalone-test`: Executes cluster tests (currently runs pedant)

`standalone-destroy`: Destroys the cluster

`standalone-end-to-end`: Runs standalone recipes in sequence

### Execution
`chef-client -z -j some-attrs.json -o qa-chef-server-cluster::standalone-end-to-end`

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

Executing:
```
chef-client -z -j my-attrs.json -o qa-chef-server-cluster::standalone-end-to-end
```

1. installs a standalone cluster using the latest stable server and manage packages from packagecloud
1. enable the upgrade process
1. upgrade chef server with the package downloaed from the source link
1. run pedant
1. destroy cluster

# IGNORE BELOW THIS LINE

## Installing a Tier Cluster

## Upgrading a Tier Cluster

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
 
