class Api::V0::MarketVendorsController < ApplicationController
  def index
    render json: Market.find(params[:market_id])
    # render json: MarketVendor.all
  end
end




