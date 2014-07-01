module Admin
  class OrganizationsController < Admin::AdminController
    before_action :load_organization, except: [:index]

    def index
      @organizations = Organization
      @organizations = @organizations.where('name ILIKE ?', "%#{params[:query]}%") unless params[:query].blank?

      @counts = @organizations.group(:aasm_state).reorder(nil).count
      @counts['all'] = @counts.values.reduce(:+)

      @organizations = @organizations.where(aasm_state: params[:filter]) unless params[:filter].blank?
      @organizations = @organizations.reorder(:name).page params[:page]
    end

    def show
    end

    private

    def load_organization
      @organization = Organization.friendly.find params[:id]
    end
  end
end
