csc-repo
========

Follow the instructions for setting up configuration files and data bags from the chef-server-cluster README https://github.com/opscode-cookbooks/chef-server-cluster#requirements

### Note on knife.rb
https://github.com/opscode-cookbooks/chef-server-cluster#create-a-chefkniferb
#### Set keys names
* replace "hc-metal-provisioner" with something like "myname-metal-provisioner".
* You will use that value later in your data bags
* You need a valid client ssh key file
 * a) use one in default location (/etc/chef/client.pem)
 * b) set client_key in knife.rb to a local private key (recommended)
 * c) pass a client key option when running chef-client and knife

Doesn't really matter, but this doc asssumes the default, which I didn't want on my local workstation

### Creating aws key
https://github.com/opscode-cookbooks/chef-server-cluster#create-a-secrets-data-bag-and-populate-it-with-the-ssh-keys
* I would recommend generating new ssh keys for testing puroses.
* Set the data bag id to something you can idenfify for ec2 (myname-metal-provisioner-chef-aws-us-west-2)

### Data bags
I've pushed the non-sensitive data bags to the project

### Provision steps
1. Edit my-cluster attributes
1. don't forget your client key settings
1. knife upload data_bags cookbooks
1. berks install # note chef-cluster-server is forked for example sake
1. berks upload
1. chef-client -c .chef/knife.rb -o my-cluster::provision

#### Clean up after yourself
1. chef-client -c .chef/knife.rb -o my-cluster::clean
