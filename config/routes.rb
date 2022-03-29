Rails.application.routes.draw do
  devise_scope :user do
    # Redirests signing out users back to sign-in
    get "users", to: "devise/sessions#new"
  end
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#home"

  # Other paths
  get "about_us", to: "pages#about", as: "about_us"
  get "contact_us", to: "pages#contact", as: "contact_us"

  # Profile paths
  get "profile", to: "profiles#index", as: "profile"
  get "profile/listings", to: "profiles#listings", as: "profile_listings"
  get "profile/orders", to: "profiles#orders", as: "profile_orders"

  # listings paths
  get "listings", to: "listings#index", as: "listings" #=> get listings index - displays all listings
  post "listings", to: "listings#create" #=> post request to create new listing
  get "listings/new", to: "listings#new", as: "new_listing" #=> get new listing form => displays page to submit new listing
  get "listings/:id", to: "listings#show", as: "listing" #=> get single listing
  get "listings/:id/edit", to: "listings#edit", as: "edit_listing" #=> get update listing page => displays page to edit selected listing
  put "listings/:id", to: "listings#update" #=> put/patch request to update listing after edting
  patch "listings/:id", to: "listings#update" #=> put/patch request to update listing after edting
  delete "listings/:id", to: "listings#destroy", as: "delete_listing" 

  # payments routes
  get "/payments/success/:id", to: "payments#success", as: "payments_success"
  post "/payments/webhook", to: "payments#webhook"
end
