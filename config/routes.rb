Rails.application.routes.draw do
  devise_for :users
  concern :likable do
    resource :likes, only: [ :create, :destroy ]
  end
  concern :comentable do
    resource :comments, only: [ :create ]
  end
  resources :users, only: [ :show, :index ]
  resources :requests, only: [ :create, :index, :destroy ]
  resources :followships, only: [ :create, :index ]
  resources :posts, only: [ :create, :destroy, :update, :index, :show ], concerns: [ :likable, :comentable ]
  resources :comments, only: [ :destroy, :update ], concerns: [ :likable, :comentable ]
  get "/followships/followers", to: "followships#followers"
  get "/requests/sent", to: "requests#sent_requests"
  delete :followships, to: "followships#destroy"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root "posts#index"
end
