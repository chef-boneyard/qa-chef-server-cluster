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
* Rspec tests for running install and upgrade iterations

### Always pull from artitactory
* stable releases too

# stable install, latest upgrade, standalone
generate-config --server-upgrade-source artifactory --enable-upgrade --run-recipe standalone-end-to-end

# latest install, standalone
generate-config --server-install-source artifactory --run-recipe standalone-end-to-end

# latest install, tier
generate-config --server-install-source artifactory --run-recipe tier-end-to-end
