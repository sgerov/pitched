Rails.application.routes.draw do
  get "*path" => redirect("https://pitchium.gerov.es/%{path}"), :constraints => { :protocol => "http" }

  root 'pitches#new'

  resources :pitches, only: [:new, :index, :update]
  post '/upload' => 'pitches#upload'
  get  '/status' => 'pitches#status'
end
