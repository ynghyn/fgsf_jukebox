Rails.application.routes.draw do
  root 'juke#list'


  get 'juke/control', to: 'juke#index'
  get 'juke/playing_now', to: 'juke#playing_now'
  get 'juke/play_button', to: 'juke#play_button'
  get 'juke/list', to: 'juke#list'
  get 'juke/add_song', to: 'juke#add_song'
  get 'juke/stop', to: 'juke#stop'
  get 'juke/next', to: 'juke#next'
  get 'juke/previous', to: 'juke#previous'
  get 'juke/play', to: 'juke#play'
  get 'juke/pause', to: 'juke#pause'
  get 'juke/clear', to: 'juke#clear'
  get 'juke/title', to: 'juke#title'
  get 'juke/time', to: 'juke#time'

  resources :comments
end
