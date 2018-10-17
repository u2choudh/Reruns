require 'json'

class RerunFavoritesController < ApplicationController
  def index
    @all_series = Series.all

    @no_series = false
    
    if @all_series.count == 0
      @no_series = true
    end
  end

  def generate_episode
    random_season = params[:seasons].sample

    episodes = Episode.where(season: random_season, series_id: params[:id])
    random_episode = episodes.sample

    respond_to do |format|
      format.json { render json: random_episode }
    end
  end

  def delete_series
    series = Series.find(params[:id])

    if series
      series.destroy
    end 
    
    respond_to do |format|
      format.json { render json: true }
    end
  end
end
