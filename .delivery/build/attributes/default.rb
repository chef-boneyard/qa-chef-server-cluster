#
# Cookbook Name:: build
# Attributes:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_attribute 'delivery-matrix'

default['chef-server-acceptance'] = {}
default['chef-server-acceptance']['identifier'] = 'standalone-clean'
default['chef-server-acceptance']['upgrade'] = false
default['chef-server-acceptance']['delivery-path'] ='/opt/chefdk/embedded/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games'

# By including this recipe we trigger a matrix of acceptance envs specified
# in the node attribute node['delivery-matrix']['acceptance']['matrix']
if node['delivery']['change']['stage'] == 'acceptance'
  default['delivery-matrix']['acceptance']['matrix'] = [
    # fresh install of chef_server_version
    'standalone_clean_aws',
    'tier_clean_aws',
    'ha_clean_aws',

    #chef_server_latest_released_version > chef_server_version upgrade testing
    'standalone_upgrade_aws',
    'tier_upgrade_aws',
    'ha_upgrade_aws',

    # OSC 11.latest > chef_server_version upgrade testing (standalone only)
    'standalone_osc_upgrade_aws',

    # EC 11.latest > chef_server_version upgrade testing
    'standalone_ec_upgrade_aws',
    'tier_ec_upgrade_aws',
    # Commented out because it is so unreliable as to tell us nothing useful.
    # 'ha_ec_upgrade_aws'
  ]
end

# Run chef-server-ctl test --all during the functional phase. Disabled by default
# as chef-server-ctl test is run in the smoke phase.
default['chef-server-acceptance']['functional']['test_all'] = false

default['chef_server_instance_size'] = 'm3.medium'

# These set the version of the Chef Server that we intend to test.
default['chef_server_test_flavor'] = 'chef_server'
default['chef_server_test_version'] = 'latest'
default['chef_server_test_channel'] = 'current'
#testing comment
default['chef_server_test_url_override'] = 'http://artifactory.chef.co/omnibus-current-local/com/getchef/chef-server/12.7.0+20160629212030/ubuntu/14.04/chef-server-core_12.7.0+20160629212030-1_amd64.deb'

# In upgrade scenarios these set the version of the Chef Server you intend
# to upgrade from. These need to be set in each test recipe but are here for
# reference.
#default['chef_server_upgrade_from_flavor'] = 'enterprise_chef'
#default['chef_server_upgrade_from_version'] = '11.3.2'
#default['chef_server_upgrade_from_channel'] = 'stable'
# default['chef_server_upgrade_from_url_override'] = 'http://wilson.ci.chef.co/view/Chef%20Server%2012/job/chef-server-12-build/lastSuccessfulBuild/architecture=x86_64,platform=ubuntu-10.04,project=chef-server,role=builder/artifact/omnibus/pkg/chef-server-core_12.2.0+20150901045019-1_amd64.deb'

default['ami'] = {
  'ubuntu-14.04' => 'ami-3d50120d',
  'ubuntu-12.04' => 'ami-0f47053f'
}
