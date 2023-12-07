class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActionController::ParameterMissing, with: :wrong_parameters_response

  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  def create
    vendor = Vendor.create(vendor_params)
    render json: VendorSerializer.new(vendor), status: :created, location: api_v0_vendor_path(vendor)
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
 
  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end

  def wrong_parameters(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 422))
      .serialize_json, status: :unprocessable_entity
  end
end
