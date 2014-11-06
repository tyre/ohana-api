class HomeController < ApplicationController

  def index
    # for now, just redirect to our own admin interface
    redirect_to sfadmin_root_path
  end
  
end
