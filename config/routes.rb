Rails.application.routes.draw do
  root 'pitches#new'

  resources :pitches
  post '/upload' => 'pithces#upload'
end
