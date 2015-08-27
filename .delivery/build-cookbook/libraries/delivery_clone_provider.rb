class Chef
  class Provider
    class DeliveryClone < DeliveryGithub

      def action_clone
        converge_by "Clone #{new_resource.remote_url}" do
          create_deploy_key
          create_ssh_wrapper_file
          create_git_remote
          clone_from_gitub
          new_resource.updated_by_last_action(true)
        end
      end

      private

      #
      # Clone the specified branch from the github remote
      #
      def clone_to_github
        git_remote_shell_out("git clone #{new_resource.remote_url}")
    end
  end
end
