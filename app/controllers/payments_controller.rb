class PaymentsController < ApplicationController
    # need to skip auth as the request is coming from stripe api, an outside source
    before_action :authenticate_user!, only: %i{success} #=> checks is there a user logged in, if not redirect to sign in page
    skip_before_action :verify_authenticity_token, only: [:webhook]
    before_action :set_order, only: %i{success}
    # authorise user so cannot be accessed via URL
    before_action :authorize_user, only: %i{success}

    def success
        
    end

    def webhook
        # check with stripe signing secret matches webhook.
            # create event
            # payload = body of request (all the data that comes from the request = params) - Stripe is sending a post request
            # header
            # endpoint_secret
        begin          
            # assign the body of the webhook params has payload
        payload = request.raw_post
            # assign stripe header (signature) - check if header has stripe signiture
        header = request.headers["HTTP_STRIPE_SIGNATURE"]
        secret = Rails.application.credentials.dig(:stripe, :webhook_signing_secret)
            # check stripe header matches webhook signature in credentials -> if so save event as 'event' variable
        event = Stripe::Webhook.construct_event(payload, header, secret)
        rescue Stripe::SignatureVerificationError => e
            # error when Stripe tries to check signature -> if invalid signature then error is raised and this error is rescued here. Return ending post request before any other line is executed
            render json: {error: "Unauthorised"}, status: 403
            return
        rescue JSON::ParserError => e
            # rescue if issue with request, return ending post request before any other line is executed
            render json: {error: "Bad Request"}, status: 422
            return
        end

        # store current payment intent as variable
        payment_intent_id = event.data.object.payment_intent
        payment = Stripe::PaymentIntent.retrieve(payment_intent_id)
        # store stripe metadata as vriables for use
        listing_id = payment.metadata.listing_id
        buyer_id = payment.metadata.user_id
        receipt = payment.charges.data[0].receipt_url
        # set current listing as variable
        @listing = Listing.find(listing_id)
        new_quantity = @listing.quantity - 1
        # update quantity on currenty listing to be the current amount less the amount purchased
        @listing.update(quantity: new_quantity)
        # Create order/purchase and track extra info
        Order.create(listing_id: listing_id, seller_id: @listing.user_id, buyer_id: buyer_id, payment_id: payment_intent_id, receipt_url: receipt)
    end

    private

    def set_order
        @order = Order.find_by(listing_id: params[:id])
    end

    def authorize_user
        if @order.buyer_id != current_user.id
          redirect_to root_path, alert: "You don't belong there. Sending you back home!"
        end
    end

end
