class OrdersController < ApplicationController 
  #before_action :authenticate_user!

  def show 
    @order = Order.find(params[:id])
  end 

  def new 
    @order = Order.new
  end 

  def index
   @orders = Order.all.reverse_order
  end

  def new_card
    respond_to do |format|
      format.js
    end
  end

  def success
  end


  def create_card 
    respond_to do |format|
      if current_user.stripe_id.nil?
        customer = Stripe::Customer.create({"email": current_user.email}) 
        #here we are creating a stripe customer with the help of the Stripe library and pass as parameter email. 
        current_user.update(:stripe_id => customer.id)
        #we are updating current_user and giving to it stripe_id which is equal to id of customer on Stripe
      end

      card_token = params[:stripeToken]
      #it's the stripeToken that we added in the hidden input
      if card_token.nil?
        format.html { redirect_to billing_path, error: "Oops"}
      end
      #checking if a card was giving.

      customer = Stripe::Customer.new current_user.stripe_id
      customer.source = card_token
      #we're attaching the card to the stripe customer
      if customer.save
        # TODO: create a local order
      end 
      format.html { redirect_to success_path }
    end
  end

  private 

  def order_params 
  end 

end
