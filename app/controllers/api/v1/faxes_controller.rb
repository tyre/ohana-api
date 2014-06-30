module Api
  module V1
    class FaxesController < ApplicationController
      include TokenValidator

      def index
        location = Location.find(params[:location_id])
        faxes = location.faxes
        render json: faxes, status: 200
      end

      def update
        fax = Fax.find(params[:id])
        fax.validate = true
        fax.update!(params)
        render json: fax, status: 200
      end

      def create
        location = Location.find(params[:location_id])
        fax = location.faxes.build(params)
        fax.validate = true
        fax.save!
        render json: fax, status: 201
      end

      def destroy
        fax = Fax.find(params[:id])
        fax.destroy
        head 204
      end
    end
  end
end
