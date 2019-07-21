require 'stripe'
Stripe.api_key = ENV['STRIPE_SECRET']

# stripe_client_id = 'ca_FThWZ8to7Rystw7UH6toHaZyAVvtmwEn'
# https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_FThWZ8to7Rystw7UH6toHaZyAVvtmwEn&scope=read_write

# To do subscription:
# Create a plan:
# Stripe::Plan.create({
#   amount: 5000,
#   interval: 'month',
#   product: {
#     name: 'Gold special',
#   },
#   currency: 'usd',
#   id: 'gold-special',
# })

# Create a customer
# Stripe::Customer.create({
#   description: 'Customer for jenny.rosen@example.com',
#   source: 'tok_visa', # obtained with Stripe.js
# })

# Create a subscription
# Stripe::Subscription.create({
#   customer: 'cus_FTgz9RA2253h8O',
#   items: [
#     {
#       plan: 'gold-special',
#     },
#   ],
# })
