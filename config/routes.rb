Rails.application.routes.draw do
  root 'juke#list'
  get 'comments/report', to: 'comments#report'
  get 'comments/local_time_refresh', to: 'comments#local_time_refresh'


  # Main pages
  get 'juke/control', to: 'juke#index'
  get 'juke/list', to: 'juke#list'

  # Partials
  get 'juke/playing_now', to: 'juke#playing_now'
  get 'juke/play_button', to: 'juke#play_button'
  get 'juke/song_info', to: 'juke#song_info'
  get 'juke/coming_up', to: 'juke#coming_up'
  get 'juke/artwork', to: 'juke#artwork'
  get 'juke/list', to: 'juke#list'
  get 'juke/title', to: 'juke#title'
  get 'juke/feed_comment', to: 'juke#feed_comment'

  # Images
  get 'juke/mp3_image', to: 'juke#mp3_image'
  get 'juke/construction', to: 'juke#construction'

  # ControlAPI
  get 'juke/add_song', to: 'juke#add_song'
  get 'juke/stop', to: 'juke#stop'
  get 'juke/next', to: 'juke#next'
  get 'juke/previous', to: 'juke#previous'
  get 'juke/play', to: 'juke#play'
  get 'juke/pause', to: 'juke#pause'
  get 'juke/pause_or_play', to: 'juke#pause_or_play'
  get 'juke/clear', to: 'juke#clear'

  resources :comments
end
