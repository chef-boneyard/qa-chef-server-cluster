# Configuration Patterns
This document defines sets of common configuration that will executed for testing.

### Install using latest stable packages
NOTHING!  That's right. Just run the `::default` recipe without a config or
just run the `::<tier|ha>-cluster or ::standalone-server` recipe to only install a cluster.

### Install latest stable server then upgrade to latest integration
```
$ generate-config --enable-upgrade
# default attributes
```

### Install server from latest integration build
```
$ generate-config --server-install-version latest-current
```

### Install / Upgrade Manage
```
$ generate-config --server-install-version latest-current --manage-install-version 1.6.2
# or maybe 1.7.1+
```

### Poke around after end-to-end recipe provision
```
$ generate-config --disable-auto-destroy
```
