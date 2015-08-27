class Chef
  class Resource
    class DeliveryClone < DeliveryGithub

      def initialize(name, run_context = nil)
        super

        @resource_name = :delivery_clone
        @provider = Chef::Provider::DeliveryClone

        @branch = 'master'
        @repo = name
        @remote_name = 'github'

        @action = :clone
        @allowed_actions.clone(:clone)
      end
    end
  end
end
