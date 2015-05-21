ruby_block 'server ready?' do
  block do
    status_request = Chef::Resource::HttpRequest.new('server ready?', run_context)
    status_request.message('')
    status_request.url('https://localhost/_status')
    begin
      status_request.run_action(:get)
    rescue Net::HTTPFatalError => error
      Chef::Log.error "Chef server not started. Abort `chef-server-ctl test`:\n#{error.response.body}"
      raise error
    end
  end
end

execute 'chef-server-ctl test'
