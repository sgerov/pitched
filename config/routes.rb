Rails.application.routes.draw do
  root 'pitches#new'

  resources :pitches
  post '/upload' => 'pitches#upload'
end
