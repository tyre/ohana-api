module Sfadmin
  class ImportJobsController < Sfadmin::AdminController
    def index
    	@import_jobs = current_admin.import_jobs
    end

    def new
    	@import_job = ImportJob.new
    end

    def create
    	@import_job = current_admin.import_jobs.build params[:import_job]
    	if @import_job.save
    		redirect_to sfadmin_import_jobs_path
    	else
    		render :new
    	end
    end

    def show

    end

    def edit

    end

    def update

    end

    def destroy

    end
  end
end