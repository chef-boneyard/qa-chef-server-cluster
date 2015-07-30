class Chef::Provider::ChefPackage < Chef::Provider::LWRPBase
  include QaChefServerCluster::ChefPackageHelper

  use_inline_resources

  def whyrun_supported?
    true
  end

  action :install do
    install_product(new_resource)
  end

  action :upgrade do
    if %w( chef-server private-chef ).include?(new_resource.product_name)
      run_chef_server_upgrade_procedure(new_resource)
    else
      install_product(new_resource)
    end
  end

  action :reconfigure do
    reconfigure_product(new_resource)
  end
end
