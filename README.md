qa-chef-server-cluster
========

## Usage
```bash
# Execute bundler and berkshelf
# This is done on-demand because of the increased overhead
rake prep 
```

```bash
rake provision[standalone|tier]
```

```bash
rake pedant[standalone|tier]
```

```bash
rake clean[standalone|tier]
```

## Setup (manual)
Until more easily configurable set the key names in:
* .chef/knife.rb
* qa-chef-server-cluster cookbook attributes file
* [Setup ssh keys data bag](https://github.com/opscode-cookbooks/chef-server-cluster#create-a-secrets-data-bag-and-populate-it-with-the-ssh-keys)
* topology data bag `topology` setting

`rake -T`
