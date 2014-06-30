module Api
  module V1
    class AddressController < ApplicationController
      include TokenValidator

      def update
        address = Address.find(params[:id])
        address.validate = true
        address.update!(params)
        render json: address, status: 200
      end

      def create
        location = Location.find(params[:location_id])
        unless location.address.present?
          address = location.build_address(params)
          address.validate = true
          address.save!
        end
        render json: address, status: 201
      end

      def destroy
        location = Location.find(params[:location_id])
        location.validate = true
        address_id = location.address.id
        location.address_attributes = { id: address_id, _destroy: '1' }
        location.save!
        head 204
      end
    end
  end
end
