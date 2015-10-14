module ChefServerAcceptanceCookbook
  module Helpers
    include Chef::Mixin::ShellOut

    # This is a temporary solution to the frequent
    #  and intermittent AuthFailure exceptions
    def shell_out_retry(command_string)
      attempt = 1
      begin
        env_hash = {	
                     'AWS_CONFIG_FILE' => File.join(node['delivery']['workspace']['cache'], '.aws/config')
                   }
        client_run = Mixlib::ShellOut.new(command_string, live_stream: STDOUT, timeout: 7200, environment: env_hash)
        client_run.run_command
        client_run.error!
      rescue Mixlib::ShellOut::ShellCommandFailed => exception
        if client_run.stdout =~ /AWS::EC2::Errors::AuthFailure/
          if attempt <= 10
            Chef::Log.error "AWS::EC2::Errors::AuthFailure after #{attempt} attempt(s)!"
            attempt = attempt + 1
            Chef::Log.info "Waiting one minute before retry..."
            sleep 60
            retry
          else
            raise "AWS::EC2::Errors::AuthFailure after 10 attempts!"
          end
        else
          raise exception
        end
      end
    end
  end
end

Chef::Resource::RubyBlock.send(:include, ::ChefServerAcceptanceCookbook::Helpers)
