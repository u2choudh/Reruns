class ImdbScraper
  def initialize(url)
    response = HTTParty.get(url)
    @search_response = Nokogiri::HTML(response)
  end

  def search_title
    series_results = []
    counter = 0

    @search_response.css('div.lister-item-content').each do |result|
      if counter == 5 
        break
      end
      curr_series = []
      
      # Information to display including title, url, rating and year
      curr_series.push(result.at_css('a').content)
      curr_series.push(result.at_css('a')["href"])
      curr_series.push(result.at_css('span.lister-item-year').content)
      rating = result.at_css('div.ratings-imdb-rating strong')
      
      if rating
        curr_series.push(rating.content)
      else
        curr_series.push("Not Available")
      end
      
      series_results.push(curr_series)
      counter = counter + 1
    end

    return series_results
  end

  def add_new(title, url, rating, year, series_url)
    begin
      season_count = @search_response.css('div.clear strong').text
      season_count = season_count[-2..-1].strip
    rescue StandardError => e 
      return e
    end

    box_art = @search_response.at_css('div.subpage_title_block img').attr('src')
    box_art = /.*_V1_/.match(box_art)[0] + ".jpg"

    # getting netflix code for series
    netflix_code = File.read('showtitles.txt').match(/^#{title}.*/i)
    
    if !netflix_code.nil?
      netflix_code = netflix_code[0].last(8)
    else
      netflix_code = false
    end

    series = Series.create!(title: title, url: url, seasons: season_count, rating: rating, year: year, image: box_art)
    
    season_count = season_count.to_i
    
    # open netflix json file for series only if code exists
    if !(netflix_code == false) 
      file = File.read("showepisodedatabase/#{netflix_code}.json")
    end
    
    while season_count > 0
      response = HTTParty.get(series_url + "/episodes?season=#{season_count}")
      parse_current_page = Nokogiri::HTML(response)
      
      # getting specific season hash of netflix id's
      netflix_episodes = {} 
      if !(netflix_code == false)
        data_hash = JSON.parse(file)
        data_hash['video']['seasons'].each do |season|
          if season['seq'] == season_count
            netflix_episodes = season['episodes']
            break
          end
        end
      end

      # Scrape info for each episode and create it
      parse_current_page.css('div.list_item').each do |episode|
        title = episode.at_css('strong').content
        description = episode.at_css('div.item_description').content.strip
        ep_number = episode.at_css('div.hover-over-image').content.strip[-2..-1]
        ep_number[0] == 'p' ? number = ep_number[1] : number = ep_number
        rating = episode.at_css('span.ipl-rating-star__rating').content

        # getting netflix code for episode
        netflix_id = 0
        if !(netflix_code == false)
          netflix_episodes.each do |episode|
            if episode['seq'] == number.to_i
              netflix_id = episode['id']
              break
            end 
          end
        end

        Episode.create!(title: title, description: description, epnum: number, rating: rating, season: season_count, series_id: series.id, netflix_id: netflix_id)
      end

      season_count = season_count - 1
    end
    
    return true
  end
end