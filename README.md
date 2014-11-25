qa-chef-server-cluster
========

== Usage
```bash
rake prep # Execute bundler and berkshelf.  This is done on-demand because of the increased overhead
```

```bash
rake provision[standalone]
```


Until more easily configurable set the key names in:
* .chef/knife.rb
* qa-chef-server-cluster cookbook attributes file
* [Setup ssh keys data bag](https://github.com/opscode-cookbooks/chef-server-cluster#create-a-secrets-data-bag-and-populate-it-with-the-ssh-keys)

=== Standalone


=== Tier

`rake -T`
