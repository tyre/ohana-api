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
        raise @location.errors.full_messages.to_s
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
      permitted_params[:accessibility] -= ['0']
      permitted_params[:address_attributes] = permitted_params[:address] if permitted_params.has_key?(:address)
      permitted_params
    end
  end
end
