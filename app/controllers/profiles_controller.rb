class ProfilesController < ApplicationController
    before_action :authenticate_user!

    def index
        
    end
    
    def orders
        @orders = Order.where(buyer_id: current_user.id)
    end

    def listings
        @listings = Listing.where(user_id: current_user.id)
    end

end
