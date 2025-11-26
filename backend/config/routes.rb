Rails.application.routes.draw do
  namespace :api do
    post "ai_agent", to: "ai_agent#ai_agent"
    post "ai_agent/with_tools", to: "ai_agent#ai_agent_with_tools"
    
    namespace :mcp do
      get "tools", to: "mcp#tools"
      post "call", to: "mcp#call"
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
