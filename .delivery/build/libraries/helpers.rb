module ChefServerAcceptanceCookbook
  module Helpers
    include Chef::Mixin::ShellOut

    def run_chef_client(recipe, options = {})
      ruby_block "Converge recipe #{recipe}" do
        block do
          repo = node['delivery']['workspace']['repo']
          repo_config_file = File.join(repo, '.chef', 'config.rb')

          command = []
          command << 'chef-client -z'
          command << "-j #{options[:attributes_file]}" if options[:attributes_file]
          command << "-c #{repo_config_file}"
          command << "-o qa-chef-server-cluster::#{recipe}"
          command << '--force-formatter'

          env_hash = {
                       'AWS_CONFIG_FILE' => File.join(node['delivery']['workspace']['cache'], '.aws', 'config')
                     }

          chef_client = Mixlib::ShellOut.new(command.join(' '),
                                             live_stream: STDOUT,
                                             timeout: 7200,
                                             environment: env_hash,
                                             cwd: repo)
          chef_client.run_command
          chef_client.error!
        end
      end
    end

    def attributes_functional_file
      ::File.join(node['delivery']['workspace']['repo'], 'functional.json')
    end

    def attributes_install_file
      ::File.join(node['delivery']['workspace']['repo'], 'install.json')
    end

    def attributes_upgrade_file
      ::File.join(node['delivery']['workspace']['repo'], 'upgrade.json')
    end

    # Return the attributes required for our initial Chef Server installation.
    # In the case of upgrades this will be the upgrade from Chef Server version.
    # If we're not doing an upgrade the we'll simply install the package we
    # wish to test.
    def attribute_install_variables
      if node['chef-server-acceptance']['upgrade']
        vars =
          if node['chef_server_upgrade_from_url_override']
            { url_override: node['chef_server_test_from_url_override'] }
          else
            { version: node['chef_server_upgrade_from_version'],
              channel: node['chef_server_upgrade_from_channel']
            }
          end
        vars.merge!(flavor: node['chef_server_upgrade_from_flavor'])
        vars
      else
        attribute_upgrade_variables
      end
    end

    # Return the attributes required to upgrade to our desired test version.
    def attribute_upgrade_variables
      vars =
        if node['chef_server_test_url_override']
          { url_override: node['chef_server_test_url_override'] }
        else
          { version: node['chef_server_test_version'],
            channel: node['chef_server_test_channel']
          }
        end
      vars.merge!(flavor: node['chef_server_test_flavor'])
      vars
    end

    def functional_test_all?
      node['chef-server-acceptance']['functional']['test_all']
    end

    def store_machine_data(identifier, machines)
      ruby_block "Store data for machine(s) #{machines.join(', ')}" do
        block do
          repo = node['delivery']['workspace']['repo']

          # load the json that represents this machine
          node.run_state['delivery'] ||= {}
          node.run_state['delivery']['stage'] ||= {}
          node.run_state['delivery']['stage']['data'] ||= {}
          node.run_state['delivery']['stage']['data'][identifier] ||= {}

          machines.each do |machine|
            node.run_state['delivery']['stage']['data'][identifier][machine] = JSON.parse(
              File.read(File.join(repo, '.chef', 'nodes', "default-#{machine}.json"))
            )
          end
        end
      end
    end

    def write_machine_data(identifier, machines)
      ruby_block "Write data for machine(s) #{machines.join(', ')}" do
        block do
          repo = node['delivery']['workspace']['repo']

          machines.each do |machine|
            retries 1
            retry_delay 30
            machine_state = ::Chef.node.run_state['delivery']['stage']['data'][identifier][machine]
            IO.write(File.join(repo, '.chef', 'nodes', "default-#{machine}.json"),
                     machine_state.to_json)
          end
        end
      end
    end

    def store_data_bag(identifier, data_bag, data_bag_item)
      ruby_block "Store data dag #{data_bag}:#{data_bag_item}" do
        block do
          repo = node['delivery']['workspace']['repo']
          data_bag_item_file = File.join(repo, 'data_bags', data_bag, "default-#{data_bag_item}.json")

          if File.exist?(data_bag_item_file)
            node.run_state['delivery']['stage']['data'][identifier][data_bag] = JSON.parse(File.read(data_bag_item_file))
          else
            Chef::Log.warn "Data bag file '#{data_bag}' not found. Nothing to store."
          end
        end
      end
    end

    def write_data_bag(identifier, data_bag, data_bag_item)
      ruby_block "Write data dag #{data_bag}:#{data_bag_item}" do
        block do
          repo = node['delivery']['workspace']['repo']
          data_bag_state = ::Chef.node.run_state['delivery']['stage']['data'][identifier][data_bag]

          if data_bag_state.nil?
            Chef::Log.warn "Run state data for data bag '#{data_bag}' not found. Nothing to write."
          else
            IO.write(File.join(repo, 'data_bags', data_bag, "default-#{data_bag_item}.json"), data_bag_state.to_json)
          end
        end
      end
    end
  end
end

Chef::Recipe.send(:include, ::ChefServerAcceptanceCookbook::Helpers)
Chef::Resource.send(:include, ::ChefServerAcceptanceCookbook::Helpers)
