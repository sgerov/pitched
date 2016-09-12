Rails.application.routes.draw do
  root 'pitches#new'

  resources :pitches, only: [:new, :index, :update]
  post '/upload' => 'pitches#upload'
  get  '/status' => 'pitches#status'
end
