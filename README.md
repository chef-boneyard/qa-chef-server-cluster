qa-chef-server-cluster
========

# Requirements
* aws config

# Usage
1. [Configure Data Bags](docs/user-guide.md#data-bags)
1. Run `rake` to set dependencies
1. Run `chef-client -z -o qa-chef-server-cluster::standalone-end-to-end` for out of the box functionality
1. Review [User Guide](docs/user-guide.md)
 * [JSON Attributes](docs/user-guide.md#setting-json-attributes-via-chef-client)
 * [JSON Generator](docs/user-guide.md#generate-json-attributes)
