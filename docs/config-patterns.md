# Configuration Patterns
This document defines sets of common configuration that will executed for testing.

### Install using latest stable packages
NOTHING!  That's right. Just run the end-to-end recipe without a config.

### Install stable server and manage then upgrade server from the latest integration build published to artifactory
```
$ generate-config --server-upgrade-source artifactory --enable-upgrade
```

### Install server from dev build and stable manage
```
$ generate-config --server-install-source artifactory
```

### Install stable server then upgrade server from artifactory and manage from some remote location (one-off from jenkins perhaps)
```
$ generate-config --server-upgrade-source artifactory --manage-upgrade-source 'http://package.location' --enable-upgrade 
```

### Poke around
```
$ generate-config --disable-auto-destroy
```
