DGLB::Application.routes.draw do
  root to: 'entries#index'
  devise_for :users, skip: :registration
  resources :entries
  resources :users do
    resources :entries, controller: 'user_entries', only: :index
  end
  resources :entries do
    resources :comments, only: [:edit, :update, :create, :destroy]
  end
  resources :entries do
    resources :versions, controller: 'entry_versions', only: [:index, :show]
  end
  resource :profile, only: [:edit, :update]

  resources :entry_docs, only: :show
  resources :entry_htmls, only: :show
  post 'versions/:id/revert' => 'versions#revert', :as => 'revert_version'

  match "tutorial" => "tutorial#index", :via => :get
  match 'hundredlemma' => 'home#hundredlemma', :via => :get
end
