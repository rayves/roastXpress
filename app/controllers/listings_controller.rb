class ListingsController < ApplicationController
# give access to listing for specified actions
  before_action :set_listing, only: %i{show edit update destroy}
  before_action :set_form_vars, only: %i{new edit}

  def index
    @listings = Listing.all
  end

  def show
  end

  def new
    # so that there is a partial to pick up errors. There won't be errors on an empty listing
    @listing = Listing.new
  end

  def create
    # action to create new listing for current logged in user passing through the permitted params
    @listing = current_user.listings.new(listing_params)
    if @listing.save
      redirect_to @listing, notice: "Listing was successfully created"
    else
      set_form_vars
      render "new", status: 422
    end
    
  end

  def edit
    
  end

  def update
    @listing = Listing.update(listing_params)
    if @listing.save
      redirect_to @listing, notice: "Listing was successfully updated"
    else
      set_form_vars
      render "edit", status: 422
    end
  end

  def destroy
    @listing.destroy
    redirect_to listings_path, notice: "Listing Sucessfully deleted"
  end
end

private

def listing_params
  params.require(:listing).permit(:name, :size, :price, :description, :quantity, :origin, :roast_type, :grind_type_id, :picture)
end

def set_listing
  @listing = Listing.find(params[:id])
end

def set_form_vars
  @grind_types = GrindType.all
  @roast_types = Listing.roast_types.keys
end