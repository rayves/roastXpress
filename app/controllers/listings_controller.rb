class ListingsController < ApplicationController
  def index
    @listing = Listing.all
  end

  def show
  end

  def new
    @listing = Listing.new
  end

  def create
    @listing = current_user.listings.new(listing_params)
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
