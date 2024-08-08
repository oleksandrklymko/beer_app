class BeersController < ApplicationController
  require 'net/http'
  require 'json'

  before_action :fetch_beers, only: %i[index]

  PER_PAGE_LIMIT = 10
  OPEN_BREWERY_API_BASE_URL = 'https://api.openbrewerydb.org/v1'.freeze
  FETCH_BEERS_URL = "#{OPEN_BREWERY_API_BASE_URL}/breweries?per_page=#{PER_PAGE_LIMIT}".freeze
  SEARCH_BEERS_URL = "#{OPEN_BREWERY_API_BASE_URL}/breweries/search".freeze

  def index; end

  def search
    query = params[:query]
    @beers = if query.present? && query.length > 3
               search_beers(query)
             else
               []
             end

    respond_to do |format|
      format.html { render :index }
      format.turbo_stream
    end
  end

  private

  def fetch_beers
    uri = URI(FETCH_BEERS_URL)
    response = Net::HTTP.get(uri)
    @beers = JSON.parse(response)
  end

  def search_beers(query)
    uri = URI("#{SEARCH_BEERS_URL}?query=#{query}&per_page=#{PER_PAGE_LIMIT}")
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end
end
