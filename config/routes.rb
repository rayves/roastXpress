Rails.application.routes.draw do
  devise_scope :user do
    # Redirests signing out users back to sign-in
    get "users", to: "devise/sessions#new"
  end
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#home", as: "home"

  # Other paths

  # listings paths
  get "listings", to: "listings#index", as: "listings" #=> get listings index - displays all listings
  post "listings", to: "listings#create" #=> post request to create new listing
  get "listings/new", to: "listings#new", as: "new_listing" #=> get new listing form => displays page to submit new listing
  get "listings/:id", to: "listings#show", as: "listing" #=> get single listing
  get "listings/:id/edit", to: "listings#edit", as: "edit_listings" #=> get update listing page => displays page to edit selected listing
  put "listings/:id", to: "listings#update" #=> put/patch request to update listing after edting
  patch "listings/:id", to: "listings#update" #=> put/patch request to update listing after edting
  delete "listings/:id", to: "listings#destroy", as: "delete_listing" 
end
