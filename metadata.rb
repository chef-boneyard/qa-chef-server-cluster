# rubocop:disable Style/SingleSpaceBeforeFirstArg
name             'qa-chef-server-cluster'
maintainer       'Patrick Wright'
maintainer_email 'patrick@chef.io'
license          'all_rights'
description      'Installs/Configures QA clusters'
version          '0.1.26'
# rubocop:enable Style/SingleSpaceBeforeFirstArg

depends 'chef-ingredient'
depends 'lvm'
depends 'apt'
depends 'build-essential'
