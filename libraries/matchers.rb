if defined?(ChefSpec)
  def install_chef_package(name)
    ChefSpec::Matchers::ResourceMatcher.new(:chef_package, :install, name)
  end

  def reconfigure_chef_package(name)
    ChefSpec::Matchers::ResourceMatcher.new(:chef_package, :reconfigure, name)
  end
end
