class ChargesController < ApplicationController

  def new
    @amount = 199
  end

  def create
    # Amount in cents
    @amount = 199

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Lesson reservation deposit',
      :currency    => 'usd'
    )

  flash[:notice] = 'Thank you! Your card has been charged successfully, please now review your instructor.'
  redirect_to root_path

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end


end
