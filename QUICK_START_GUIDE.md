Quick Start Guide
=================

## Default Configuration for Chef CI Environments
This cookbook was initially developed as a private project as we worked the details of how it would integrate with Chef's internal testing infrastructure.  Now that the cookbook is public, it is important to note that the default attributes are still configured for the internal testing infrastructure, specifically, subnets and security groups.  They are not accessible without a Chef AWS account, but are 100% configurable.  Using the default AWS settings also requires a Chef VPN connection.

## Chef Zero Setup

##### 1. Create a chef-repo and create files
`.chef/knife.rb`
```ruby
current_dir = File.dirname(__FILE__)
cookbook_path [ "#{current_dir}/../cookbooks", "#{current_dir}/../berks-cookbooks" ]
```

`./Berksfile`
```ruby
source "https://supermarket.chef.io"

# currently a private github repository
cookbook 'omnibus-artifactory-artifact', github: 'opscode-cookbooks/omnibus-artifactory-artifact'
cookbook 'qa-chef-server-cluster', github: 'chef/qa-chef-server-cluster'
```

##### 2. Install and vendor berks cookbooks
`berks install`  
`berks vendor`

##### 3. Install chef-provisioning
Create a Gemfile or manually install gems `chef-provisioning` and  `chef-provisioning-aws`.

## Provision a Standalone Chef Server
Run:  
`chef-client -z -o qa-chef-server-cluster::standalone-server`

This will create an ec2 instance and install the latest stable release of Chef Server. No configuration required.

#### Install Manage
Create an attributes json file to pass to the chef-client exec:
```json
{
  "qa-chef-server-cluster": {
    "opscode-manage": {
      "version": "latest"
    }
  }
}
```

Run:  
`chef-client -z -j attributesfile.json -o qa-chef-server-cluster::standalone-server`

#### Upgrade to the latest current Chef Server version
Create an attributes json file to pass to the chef-client exec:
```json
{
  "qa-chef-server-cluster": {
    "chef-server": { 
      "version": "12.2.0",
      "integration_builds": true,
      "repo": "omnibus-current-local"
    }
  }
}
```

`latest-current` is a keyword that is used by `omnibus-artifactory-artifact`, the default package resolver.  It will query artifactory.chef.co for the latest 12.2.0 integraton version and upgrade to that version.

Run:  
`chef-client -z -j attributesfile.json -o qa-chef-server-cluster::standalone-server-upgrade`

## Provision a Tier Cluster with the latest current Chef Server version
Use the same json [attribute file](#upgrade-to-the-latest-current-chef-server-version) used for uprading the Chef Server.

Run:  
`chef-client -z -j attributesfile.json -o qa-chef-server-cluster::tier-cluster`

Notice that neither the topology, nor whether an install or upgrade was specified in the configuration.  Topology and install/upgrades are determined by the called recipe.

