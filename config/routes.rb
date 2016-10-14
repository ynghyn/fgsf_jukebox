Rails.application.routes.draw do
  root 'juke#index'

  get 'juke/index', to: 'juke#index'
  get 'juke/list', to: 'juke#list'
  get 'juke/add_song', to: 'juke#add_song'
  get 'juke/stop', to: 'juke#stop'
  get 'juke/play', to: 'juke#play'
  get 'juke/clear', to: 'juke#clear'
end
