class Api::V0::MarketsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render json: MarketSerializer.new(Market.find(params[:id]))
  end

  def search
    if params[:state] && !params[:city] && !params[:name]
      render json: MarketSerializer.new(Market.find_market_by_state(params)), status: 200
    elsif params[:state] && params[:city] && !params[:name]
      render json: MarketSerializer.new(Market.find_market_by_state_and_city(params)), status: 200
    end
  end

  private
 
  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end
end
