module Sfadmin
  class AdminController < ApplicationController
    layout 'sfadmin'

    before_action :authenticate_user!
  end
end
