module Sfadmin
  class AdminController < ApplicationController
    layout 'sfadmin'

    before_action :authenticate_admin!
  end
end
