# Configuration Patterns
This document defines sets of common configuration that will executed for testing.

### Install using latest stable packages
NOTHING!  That's right. Just run the end-to-end recipe without a config.

### Install stable server and manage then upgrade server from dev build
```
$ generate-config --server-upgrade-source 'http://package.location' --enable-upgrade
```

### Install server from dev build and stable manage
```
$ generate-config --server-install-source 'http://package.location'
```

### Install stable server then upgrade server and manage from dev builds
```
$ generate-config --server-upgrade-source 'http://package.location' --manage-upgrade-source 'http://package.location' --enable-upgrade 
```

### Poke around
```
$ generate-config --disable-auto-destroy
```
