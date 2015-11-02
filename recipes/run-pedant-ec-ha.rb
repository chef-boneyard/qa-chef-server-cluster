# TODO: copy/paste to handle EC HA backend vip hack
ruby_block 'server ready?' do
  block do
    status_request = Chef::Resource::HttpRequest.new('server ready?', run_context)
    status_request.message('')
    status_request.url("https://#{node['qa-chef-server-cluster']['chef-server']['api_fqdn']}/_status") # Hack here
    begin
      status_request.run_action(:get)
    rescue Net::HTTPFatalError => error
      Chef::Log.error "Chef server not started.\n#{error.response.body}"
      raise error
    end
  end
end

pedant_options = node['qa-chef-server-cluster']['chef-server-ctl-test-options']

pedant_cmd = []
pedant_cmd << "#{current_server.ctl_exec} test"
pedant_cmd << pedant_options if pedant_options

execute pedant_cmd.join(' ').strip
