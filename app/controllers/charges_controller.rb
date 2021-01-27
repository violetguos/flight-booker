class ChargesController < ApplicationController
  def new; end

  def create
    # Amount in cents
    @amount = 500
    Stripe.api_key = 'sk_test_4eC39HqLyjWDarjtT1zdp7dc'
    customer = Stripe::Customer.create({
                                         email: params[:stripeEmail],
                                         source: params[:stripeToken]
                                       })

    charge = Stripe::Charge.create({
                                     customer: customer.id,
                                     amount: @amount,
                                     description: 'Rails Stripe customer',
                                     currency: 'usd'
                                   })
    flash[:notice] = 'Fictional ticket booked!' if charge
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to root_path
  end
end
