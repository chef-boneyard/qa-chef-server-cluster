# unsecured default keys
# provisioner-setup recipe will clear the private and public attributes so they are not added to any nodes
node.default['qa-chef-server-cluster']['private-key'] = "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEA2lzwvnpTObhbhrzgiOaaoj04hsGi2PIvWqQeF6dk9wP9rpPQ\nmEqCpEwVNzoOAT4hgB5VvlGBvchOkdV/4TiJGIKP6mGlHglKCEAnOir/FCP1+jb7\nIvSW6t752+tYffCA9ywRSu1OIub+fO6dQ+3nZvYT0vYttBUjHOG24F7XHvE6G6G9\nI5RF1MtCR7JWP/WOenHKtdXAPXC9eKtK6HKqh4OZVGWZOUvcOPNRyA2SfZ7XS2rl\nfgYZj0/Lxsirc6frR9jSFrHksBSUWuWQv7LhzzIi1YimR7jf//WR9CjcCm06o/Qp\nJVefpIfYFiqzFIRzpPsVcRChX4BkwBy/23B6iwIDAQABAoIBAQDQqD7jxMACR8gt\n2A42wyTAIwAAxMd3xvS5CFo5ABvablXanCSXYZu0o38iZrc7OMOKSXJlij0PvHhX\nokuwSvW2FgyvSt8c9INpnuPdEXjtJe/GSQNxQ4dyp97Z5umIbmjNx64+isQ/VbuY\nZeqhHpQgLsSCsfq6OfhzgLvfasDlLpkOwKTQPYIj2PC1CHXCUMti9GQKYKO96Xgt\nXjIjrQ/J/DsmgmISLBGTLUBdClyJpt+Pqk/vBVsFZ+hZECFtwUEuotLDxkT2F/oK\nzczrdqAtg272SWupINE2g4LRWVn31utGWA2uijHQgUgvAtF03FiTR9j4HnLGUmtk\nt3g224EBAoGBAPAmbh4JFpvpj6zF4AQDINuZDO8IK0k+aNePICQ2p5VZ5TIr0/+f\nFbvbbEdoCT+OGgUJKfVSrAwr7sKZRrodaYmPHpUqEeureAbiI2PMmfuJFpHyyu4f\ny6+GwYvEmC/G/SGt2QZH9QryHHB7/DTnfi9VIKGE+kIUxb6YPHbhHEQnAoGBAOjG\nZYMKZDYDdALPKN/+iY5vEJYXV91MJ/zXh+ICo39vPMu993fEzGoli2iEmbzxVhVn\nfq7r0hjbD3vD+QEsgOd6UEYvXiNqhucRH3qMhpqEOpU6aqU+PpPtJi9v8MYYEeZZ\nHhAhs9BefZ4Vn6TMsKkaveK4c5jUdBGWyxsiieD9AoGAEUQyFqbAoWUhl2KCwMcY\nzbErZORJeHKsRxNbVD85vVtBR2IvU+m0PlWAa4HnaFJnPIV0JtdS120xNXyfwTHs\nLJ/FqyPjNfaWIqiPstU7HQK2RLgYLxbKJkyiDdKMvqKoAIvnVrRFwgu2T8AaWhNq\n1yxftD1DYQztSs7XShTVW3ECgYAWerpo6kL9OF4mu0zOPO2Z1L38UKrKk0U1VLcp\nq2mQr/RmFKVmapn3EkMhR9T0+zV+Aa2pRNrYTad0I1vTsjGMqTJBZOepcesvO2cX\n1aRWHbjummKcLKOsc3WBlUTiTIbGAQs3MZoE4GsvLhVpu96/pfZ6g6eeNb4zyKU6\nrJ42HQKBgF5g0H0HvSlKRhVsISdINHKXcB++d+mYz3f7i8o88bxsB9IU7xOKiNPY\n3pjf2xfYScjHZOg+T93YfOtP7NY9bc5yuTYvXC7/5bMK/5zvxwhFYGkNuD53113m\n5KwYhHhWLiizsCC6ghbgDHbf1heu+Wn7IOwRG7wh3QaDm0JDpJ9l\n-----END RSA PRIVATE KEY-----"
node.default['qa-chef-server-cluster']['public-key'] = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDaXPC+elM5uFuGvOCI5pqiPTiGwaLY8i9apB4Xp2T3A/2uk9CYSoKkTBU3Og4BPiGAHlW+UYG9yE6R1X/hOIkYgo/qYaUeCUoIQCc6Kv8UI/X6Nvsi9Jbq3vnb61h98ID3LBFK7U4i5v587p1D7edm9hPS9i20FSMc4bbgXtce8Tobob0jlEXUy0JHslY/9Y56ccq11cA9cL14q0rocqqHg5lUZZk5S9w481HIDZJ9ntdLauV+BhmPT8vGyKtzp+tH2NIWseSwFJRa5ZC/suHPMiLViKZHuN//9ZH0KNwKbTqj9CklV5+kh9gWKrMUhHOk+xVxEKFfgGTAHL/bcHqL ociv'

node.default['qa-chef-server-cluster']['aws'].tap do |aws|
  aws['region'] = 'us-west-2'
  aws['availability_zone'] = 'b'
end

node.default['qa-chef-server-cluster']['aws']['machine_options'].tap do |machine_options|
  machine_options['aws_tags'] = { 'X-Project' => 'qa-chef-server-cluster' }
  machine_options['transport_address_location'] = :private_ip
  machine_options['ssh_username'] = 'ubuntu'
  machine_options['bootstrap_options'].tap do |bootstrap_options|
    bootstrap_options['key_name'] = 'qa-chef-server-cluster-default'
    bootstrap_options['subnet_id'] = 'subnet-d3d9b8b4' # chef-cd -- acceptance-us-west-2a-private
    bootstrap_options['security_group_ids'] = ['sg-b3ed07c8'] # acceptance-default
    bootstrap_options['image_id'] = 'ami-4218403a' # Ubuntu 14.04
    bootstrap_options['instance_type'] = 't2.large'
  end
end

node.default['qa-chef-server-cluster']['provisioning-id'] = 'default'
node.default['qa-chef-server-cluster']['topology'] = nil

node.default['qa-chef-server-cluster']['chef-server'].tap do |chef_server|
  chef_server['version'] = 'latest'
  chef_server['channel'] = 'stable'
  chef_server['flavor'] = 'chef_server'
  chef_server['api_fqdn'] = 'api.chef.sh'
  chef_server['url'] = nil # setting this will override version and channel settings
end

node.default['qa-chef-server-cluster']['opscode-manage'].tap do |opscode_manage|
  opscode_manage['version'] = nil
  opscode_manage['channel'] = 'stable'
  opscode_manage['url'] = nil # setting this will override version and channel settings
end

node.default['qa-chef-server-cluster']['chef-ha'].tap do |chef_ha|
  chef_ha['version'] =  '1.0.0'
  chef_ha['channel'] = 'stable'
  chef_ha['url'] = nil # setting this will override version and channel settings
end

node.default['qa-chef-server-cluster']['chef-server-ctl-test-options'] = ''

node.default['qa-chef-server-cluster']['download-logs'] = false

node.default['qa-chef-server-cluster']['data-generator']['branch'] = 'ssd/pool-607'
