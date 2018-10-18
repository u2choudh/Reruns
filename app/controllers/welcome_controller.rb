class WelcomeController < ApplicationController
  include ImdbScraper 
  
  def index
  end

  # Gives search result based on the series name entered
  def search_title
    reponse = get_response("https://www.imdb.com/search/title?title=#{params[:title]}")
    # series_results = ImdbScraper.new("https://www.imdb.com/search/title?title=#{params[:title]}").search_title
    series_results = search_results

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

    # series = ImdbScraper.new(url + "/episodes?season=#{season_count}").add_new_series(params[:title], params[:url], params[:rating], params[:year], url)
    reponse = get_response(url + "/episodes?season=#{season_count}")
    series = add_new_series(params[:title], params[:url], params[:rating], params[:year], url)
    episodes = add_episodes(url)
    
    render json: true
  end
end
