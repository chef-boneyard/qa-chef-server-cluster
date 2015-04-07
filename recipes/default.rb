topology = node['qa-chef-server-cluster']['topology']
enable_upgrade = node['qa-chef-server-cluster']['enable-upgrade']
run_pedant = node['qa-chef-server-cluster']['run-pedant']
auto_destroy = node['qa-chef-server-cluster']['auto-destroy']

case topology
  when 'standalone'
    include_recipe 'qa-chef-server-cluster::standalone-server'
    include_recipe 'qa-chef-server-cluster::standalone-server-upgrade' if enable_upgrade

    if run_pedant
      # TODO (pwright)
      ruby_block "race condition - boo" do
        block do
          sleep 60
        end
      end
      include_recipe 'qa-chef-server-cluster::standalone-server-test'
    end

    include_recipe 'qa-chef-server-cluster::standalone-server-destroy' if auto_destroy
  when 'tier'
    include_recipe 'qa-chef-server-cluster::tier-cluster'
    include_recipe 'qa-chef-server-cluster::tier-cluster-upgrade' if enable_upgrade

    if run_pedant
      # TODO (pwright)
      ruby_block "race condition - boo" do
        block do
          sleep 60
        end
      end
      include_recipe 'qa-chef-server-cluster::tier-cluster-test'
    end

    include_recipe 'qa-chef-server-cluster::tier-cluster-destroy' if auto_destroy

  when 'ha'
    include_recipe 'qa-chef-server-cluster::ha-cluster'
    # include_recipe 'qa-chef-server-cluster::ha-cluster-upgrade' if enable_upgrade
    # if run_pedant
    #   # TODO (pwright)
    #   ruby_block "race condition - boo" do
    #     block do
    #       sleep 60
    #     end
    #   end
    #   include_recipe 'qa-chef-server-cluster::ha-cluster-test'
    # end
    include_recipe 'qa-chef-server-cluster::ha-cluster-destroy' if auto_destroy
  when nil
    raise "Must set attribute ['qa-chef-server-cluster']['topology']"
  else
    raise "Can not provision topology type #{topology}"
end

