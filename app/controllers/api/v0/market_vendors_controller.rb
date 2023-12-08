class Api::V0::MarketVendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    market = Market.find(params[:market_id])
    vendors = market.vendors

    render json: VendorSerializer.new(vendors)
  end

  def create 
    market_vendor = MarketVendor.new(market_id: params[:market_id], vendor_id: params[:vendor_id])
    existing_market_vendor = MarketVendor.find_by(market_id: params[:market_id], vendor_id: params[:vendor_id])

    if existing_market_vendor
      render json: { errors: [detail: "#{validation_failed}" ]}, status: 422
    elsif params[:market_id].blank? || params[:vendor_id].blank?
      render json: { errors: [detail: "Market ID or Vendor ID cannot be blank" ]}, status: 400
    elsif Market.find_by(id: params[:market_id]).nil?
      render json: { errors: [detail: "Validation failed: Market must exist" ]}, status: 404
    elsif Vendor.find_by(id: params[:vendor_id]).nil?
      render json: { errors: [detail: "Validation failed: Vendor must exist" ]}, status: 404
    elsif market_vendor.save
      render json: { message: "Successfully added vendor to market"}, status: 201
    end
  end

  def destroy
    market_vendor = MarketVendor.find_by(market_id: params[:market_id], vendor_id: params[:vendor_id])

    if Market.find_by(id: params[:market_id])
      market_vendor.destroy
    else
      render json: { errors: [detail: "No MarketVendor with market_id=#{params[:market_id]} AND vendor_id=#{params[:vendor_id]} exists"]}, status: 204
    end
  end

  private
 
  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end

  def market_vendor_params
    params.permit(:market_id, :vendor_id)
  end

  def market_must_exist
    "Validation failed: Market must exist"
  end

  def validation_failed
    "Validation failed: Market vendor association between market with #{params[:market_id]} and #{params[:vendor_id]} already exists"
  end
end
