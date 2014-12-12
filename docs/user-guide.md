## Data Bags


## Installing a Standalone Cluster
`chef-client -z -o qa-chef-server-cluster::standalone-cluster`

### packagecloud chef/stable
* Default execution will install the latest chef/stable packages from packagecloud. 
* The package versions can also be specified by overridding the node attributes.
core-version.json
```json 
{ "qa-chef-server-cluster": { "chef-server-core": { "version": "VERSION" } } }
```

`chef-client -z -j core-version.json -o qa-chef-server-cluster::standalone-cluster`

### remote location
* Specify a download location other than packagecloud (like jenkins)
core-location.json
```json 
{ "qa-chef-server-cluster": { "chef-server-core": { "source": "http://domain.com/file.package" } } }
```

## Upgrading a Standalone Cluster

### remote location

## Standalone End to End
Run install, upgrade then pedant. Upon a successful pedant run the cluster will be destroyed.

1. Installs latest chef-server and manage 1.6.1
2. Upgrades manage (leaves server untouched)
3. Runs pedant
```json
{
  "qa-chef-server-cluster": { 
    "opscode-manage": { 
      "version": "1.6.1-1" 
      }
    },
  "enable-upgrade": true
}
```
`chef-client -z -j manage-version.json -o qa-chef-server-cluster::standalone-end-to-end`





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
 
