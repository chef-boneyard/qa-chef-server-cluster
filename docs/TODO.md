# TODOs and Enhancements

### Consolidate core recipes
* -test, -end-to-end, -destroy
 * will require topology attribute
* cluster and cluster-upgrade combined

### LWRP for installing packages
* source vs stable
* support all packages

### Platform Resolution
* plaftorm and version ami mappings

### generate-config clean up
* will you look at that!
* just look at it! 

### Keys
* configurable ec2 key name
* configurable ssh keys
* generate-config

### Configurable chef-repo
* needed for CI
* include json config

### CSTA Integration
* csta state?
* still the best option?

### Rspec
* Rspec tests for running install and upgrade configurations

### Always pull from artitactory
* stable releases too

### Remove static knife.rb dependency
* Run chef-client programatically or
* generate knife.rb

### Initial CI Tests
* stable install, latest upgrade, standalone

```
generate-config --server-upgrade-source artifactory --enable-upgrade --run-recipe standalone-end-to-end
```

* latest install, standalone

```
generate-config --server-install-source artifactory --run-recipe standalone-end-to-end
```

* latest install, tier

```
generate-config --server-install-source artifactory --run-recipe tier-end-to-end
```

* force cleanup. even though this runs at the end, it will not if the converge fails
 * Requires node data

```
chef-client -z -o qa-chef-server-cluster::<topology>-destroy
```
