class Api::V0::MarketVendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    market = Market.find(params[:market_id])
    vendors = market.vendors

    render json: VendorSerializer.new(vendors)
  end

  def create 
    if params[:market_id].blank? || params[:vendor_id].blank?
      render json: { errors: [{ status: "400", title: "Market ID or Vendor ID cannot be blank" }]}
      return
    end
    
    existing_market_vendor = MarketVendor.find_by(market_vendor_params)

    if existing_market_vendor
      render json: { errors: [detail: "#{validation_failed}" ]}, status: 422
      return
    end
    
    market_vendor = MarketVendor.new(market_vendor_params)

    if market_vendor.save
      render json: { message: "Successfully added vendor to market"}, status: 201
    else
      render json: { errors: [detail: "Validation failed: Market must exist"] }, status: 404
    end
  end

  def destroy
    market_vendor = MarketVendor.find_by(market_vendor_params)
    market_vendor.destroy
  end

  private
 
  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end

  def validation_failed
    "Validation failed: Market vendor asociation between market with #{params[:market_id]} and #{params[:vendor_id]} already exists"
  end
end




