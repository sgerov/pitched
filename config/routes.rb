Rails.application.routes.draw do
  root 'pitches#new'

  resources :pitches, only: [:new, :index ]
  post '/upload' => 'pitches#upload'
end
