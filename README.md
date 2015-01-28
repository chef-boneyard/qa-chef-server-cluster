[![Stories in Ready](https://badge.waffle.io/opscode/qa-chef-server-cluster.png?label=ready&title=Ready)](https://waffle.io/opscode/qa-chef-server-cluster)
Quality Advocacy Chef Server Cluster
========
Recipes for installing, upgrading and testing Chef Server 12 topologies.

# Requirements
* aws config

# Usage
1. Run `rake` to install dependencies
1. Run `chef-client -z -o qa-chef-server-cluster::standalone-server-end-to-end` for out of the box functionality
1. Review [User Guide](docs/user-guide.md)
 * [JSON Attributes](docs/user-guide.md#setting-json-attributes-via-chef-client)
 * [JSON Generator](docs/user-guide.md#generate-json-attributes)
 * [Automatic Chef Run](docs/user-guide.md#initiate-chef-run-with-generated-config)
 * [Configure Data Bags](docs/user-guide.md#data-bags)

# Test Kitchen
`kitchen list` to see available test suites

# Credit
This wrapper cookbook deserves the recognition of Paul Mooring <paul@chef.io> and 
Joshua Timberman <joshua@chef.io> for their great work on the chef-server-cluster and chef-server-ingredient cookbooks.

# License and Author
Author: Patrick Wright patrick@chef.io.com

Copyright (C) 2014 Chef Software, Inc. legal@chef.io

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
