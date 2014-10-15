csc-repo
========

Follow the instructions for setting up configuration files and data bags from the chef-server-cluster README https://github.com/opscode-cookbooks/chef-server-cluster#requirements

Note on knife.rb:
https://github.com/opscode-cookbooks/chef-server-cluster#create-a-chefkniferb
Set keys_names:
replace "hc-metal-provisioner" with something like "myname-metal-provisioner".
You will use that value later in your data bags

You need a valid client ssh key file:
a) use one in default location (/etc/chef/client.pem)
b) set client_key in knife.rb to a local private key (recommended)
c) pass a client key option when running chef-client and knife

Doesn't really matter, but this doc asssumes the default, which I didn't want on my local workstation

Note creating aws key:
https://github.com/opscode-cookbooks/chef-server-cluster#create-a-secrets-data-bag-and-populate-it-with-the-ssh-keys
I would recommend generating new ssh keys for testing puroses.
Set the data bag id to something you can idenfify in ec2 (the same value as in the knife.rb)

Other data bags: I've pushed the non-sensitive data bags to the project


Edit recipe attribute (for now)


# don't forget your client key
knife upload data_bags cookbooks
berks install
berks upload
chef-client -c .chef/knife.rb -o my-cluster::provision
chef-client -c .chef/knife.rb -o my-cluster::clean

