module ChefServerAcceptanceCookbook
  module Helpers
    include Chef::Mixin::ShellOut

    def run_chef_client(recipe, options = {})
      repo = node['delivery']['workspace']['repo']
      repo_config_file = File.join(repo, '.chef', 'config.rb')

      command = []
      command << 'bundle exec'
      command << 'chef-client -z'
      command << '-p 10257'
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

    def store_machine_data(identifier, machines)
      # load the json that represents this machine
      node.run_state['delivery'] ||= {}
      node.run_state['delivery']['stage'] ||= {}
      node.run_state['delivery']['stage']['data'] ||= {}
      node.run_state['delivery']['stage']['data'][identifier] ||= {}

      machines.each do |machine|
        node.run_state['delivery']['stage']['data'][identifier][machine] = JSON.parse(
          File.read(
            File.join(nodes_dir, "default-#{machine}.json")
          )
        )
      end
    end

    def write_machine_data(identifier, machines)
      machines.each do |machine|
        machine_state = ::Chef.node.run_state['delivery']['stage']['data'][identifier][machine]
        IO.write(File.join(nodes_dir, "default-#{machine}.json"), machine_state.to_json)
      end
    end
  end

  private

  def nodes_dir
    File.join(node['delivery']['workspace']['repo'], '.chef', 'nodes')
  end
end

#Chef::Resource::RubyBlock.send(:include, ::ChefServerAcceptanceCookbook::Helpers)
Chef::Recipe.send(:include, ::ChefServerAcceptanceCookbook::Helpers)
