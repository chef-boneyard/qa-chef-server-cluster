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
      client_run.run_command
      client_run.error!
    end
  end
end

Chef::Resource::RubyBlock.send(:include, ::ChefServerAcceptanceCookbook::Helpers)
