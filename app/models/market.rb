class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  validates :name, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :county, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates :lat, presence: true
  validates :lon, presence: true
  validates :vendor_count, presence: true

  def self.find_market_by_state(params)
    # name = params[:name]
    # city = params[:city]
    state = params[:state]

    market_info = {}

    # market_info[:name] = name if params[:name] != nil
    # market_info[:city] = city.capitalize if params[:city] != nil
    market_info[:state] = state.split.map(&:capitalize).join(" ") if params[:state] != nil

    result = Market.where(market_info)
    result
  end

  def self.find_market_by_state_and_city(params)
    # name = params[:name]
    city = params[:city]
    state = params[:state]

    market_info = {}

    # market_info[:name] = name if params[:name] != nil
    market_info[:city] = city.capitalize if params[:city] != nil
    market_info[:state] = state.split.map(&:capitalize).join(" ") if params[:state] != nil

    result = Market.where(market_info)
    result
  end
end
