DGLB::Application.routes.draw do
  root :to => "entries#index"
  devise_for :users, :skip => :registration
  resources :entries
  resources :users do
    resources :entries, controller: "user_entries" 
  end
  resource :profile, only: [:edit, :update]
  resources :comments
  # get 'user_entries/index'





  
  resources :entry_docs
  resources :entry_htmls
  resources :users_admin, controller: :users
  match "users/:id/update_role" => "users#update_role", :as => "update_user_role", :via => :put       
  match "users/:id/entries" => "users#entries", :as => "users_entries", :via => :get
  post "versions/:id/revert" => "versions#revert", :as => "revert_version"

  match "tutorial" => "tutorial#index", :via => :get
  match "hundredlemma" => "home#hundredlemma", :via => :get
end
