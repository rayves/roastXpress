class ListingsController < ApplicationController
  # before execution any action authenticate users except on the specified actions
  before_action :authenticate_user!, except: [:index, :show] #=> checks is there a user logged in, if not redirect to sign in page
  # set instance variable @listing so actions can access all listings variable
  before_action :set_listing, only: %i{show edit update destroy}
  before_action :set_form_vars, only: %i{new edit}
  # check if the listing's user id equals the current user id. If not flash alert and redirect.
  before_action :authorize_user, only: %i{edit update destroy}

  def index
    @listings = Listing.all
  end

  def show
    #create session -> use Stripe gem -> use Checkout function -> use session function with Checkout function
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      customer_email: current_user && current_user.email, #=> requires user be logged in
      line_items: [
        {
          name: @listing.name,
          description: @listing.description,
          amount: (@listing.price * 100).to_i,
          currency: 'aud',
          # adjustable_quantity: {
          #   enabled: true,
          #   minimum: 1,
          #   maximum: 10,
          # },
          quantity: 1
        }
      ],
      payment_intent_data: {
        metadata: {
          # this sends the below data to stripe and when data is retrieved, a row can be created in the database to track this. i.e. that the customer has made a payment and what they've bought.
          user_id: current_user && current_user.id,
          listing_id: @listing.id,
        }
      },
      # as there is a redirection to Stripe's website and then a redirection back after processing of payment. URLs can be added for re-direction.
      success_url: "#{root_url}payments/success/#{@listing.id}",
      cancel_url: root_url
    )

    # 'session' object has an id when created. So this can be saved by instance varaible for wider access.
    @session_id = session.id

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
    @listing.update(listing_params)
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

private

  def listing_params
    params.require(:listing).permit(:name, :size, :price, :description, :quantity, :origin, :roast_type, :grind_type_id, :picture, flavor_ids: [])
  end

  def set_listing
    @listing = Listing.find(params[:id])
  end

  # sets model rows form Grind Type and roast types as variables for use
  def set_form_vars
    @grind_types = GrindType.all
    @roast_types = Listing.roast_types.keys
    @flavors = Flavor.all
  end

  # if the listing's user id does not match that of the currently signed in user then redirect and flash alert
  def authorize_user
    if @listing.user_id != current_user.id
      redirect_to listing_path, alert: "You don't have permission to do that"
    end
  end

end

