class Admin
  class RegistrationsController < Devise::RegistrationsController
    protected

    def after_inactive_sign_up_path_for(resource)
      return new_admin_confirmation_path
    end    

    def after_sign_up_path_for(resource)
      return root_url if resource.is_a?(User)
      return sfadmin_root_path if resource.is_a?(Admin)
    end
    
  end
end
