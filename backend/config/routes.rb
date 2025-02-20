Rails.application.routes.draw do

  post 'auth/exchange_token', to: 'auth#exchange_token'

  get 'up', to: 'rails/health#show', as: :rails_health_check

  # Generator endpoints
  post 'generator/generate_encounter', to: 'generator#generate_encounter'
  post 'generator/generate_trap', to: 'generator#generate_trap'
  post 'generator/generate_quest', to: 'generator#generate_quest'
  post 'generator/generate_treasure', to: 'generator#generate_treasure'
  post 'generator/generate_npc', to: 'generator#generate_npc'
end
