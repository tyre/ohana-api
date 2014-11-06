module Sfadmin
  class DashboardController < Sfadmin::AdminController
    def index
      redirect_to [ :sfadmin, :import_jobs ]
    end
  end
end
