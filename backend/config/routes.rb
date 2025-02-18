Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check
  post 'generator/generate_encounter', to: 'generator#generate_encounter'
  post 'generator/generate_trap', to: 'generator#generate_trap'


end
