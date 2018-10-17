class WelcomeController < ApplicationController
  def index
  end

  # Gives search result based on the series name entered
  def search_title
    series_results = ImdbScraper.new("https://www.imdb.com/search/title?title=#{params[:title]}").search_title

    respond_to do |format|
      format.json { render json: series_results }
    end
  end

  # Adds a new series
  def add_new
    pp params
    series_exists = Series.exists?(title: params[:title])

    if series_exists
      render json: true
      return
    end
    
    #when season_count is more than the maximum number of series imdb defaults
    #to max current season number
    season_count = 100
    url = /.*[0-9]{7}/.match(params[:url])[0]

    results = ImdbScraper.new(url + "/episodes?season=#{season_count}").add_new(params[:title], params[:url], params[:rating], params[:year], url)
    
    render json: true
  end
end
