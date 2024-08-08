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
               fetch_beers
             end

    respond_to do |format|
      format.turbo_stream
      format.html { render :index }
    end
  end

  private

  def fetch_beers
    @beers = fetch_from_api(FETCH_BEERS_URL)
  rescue StandardError => e
    Rails.logger.error "Error fetching beers: #{e.message}"
    @beers = []
  end

  def search_beers(query)
    uri = URI(SEARCH_BEERS_URL)
    uri.query = URI.encode_www_form(query:, per_page: PER_PAGE_LIMIT)
    fetch_from_api(uri)
  rescue StandardError => e
    Rails.logger.error "Error searching beers: #{e.message}"
    []
  end

  def fetch_from_api(url)
    uri = URI(url)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  rescue JSON::ParserError => e
    Rails.logger.error "Error parsing JSON: #{e.message}"
    []
  end
end
