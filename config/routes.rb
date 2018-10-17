Rails.application.routes.draw do
  get 'rerun_favorites/index'
  get 'welcome/index'

  root 'welcome#index'

  post 'imdb/:title' => 'welcome#search_title'
  post '/add_series' => 'welcome#add_new'
  post '/generate_episode' => 'rerun_favorites#generate_episode'

  get '/rerun_favorites' => 'rerun_favorites#index'
  delete '/delete_series' => 'rerun_favorites#delete_series'
end
