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
* create `package` data bag
```json
  {
    "id": "package",
    "chef_server_core": {
      "version": "12.0.0-rc.5-1"
    },
    "opscode_manage": {
      "location": "jenkins_wilson.ci.opscode.us",
      "build": "just_guessing"
    }
  }
```
  * omit `version` to default to latest package, or set to `null`
  * `location`, `build` is not used. Just a placeholder for how we may handle downloading packages from other repos.

`rake -T`


