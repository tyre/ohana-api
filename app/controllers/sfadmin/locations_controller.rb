module Sfadmin
  class LocationsController < Sfadmin::AdminController
    def edit
      @organization = Organization.where(slug: params[:organization_id]).first!
      @location = @organization.locations.where(slug: params[:id]).first!
    end

    def update
      @location = Location.where(slug: params[:id]).first!
      if @location.update_attributes(location_params)
        redirect_to sfadmin_organization_path @location.organization
      else
        render :edit
      end
    end

    def show
      @location = Location.where(slug: params[:id]).first!
    end

    private

    def location_params
      permitted_params = params.require(:location).
                                permit(:description, :short_desc, :address, accessibility: [])
      # remove any unchecked accessibility features
      permitted_params[:accessibility] -= ['0']
      permitted_params
    end
  end
end
