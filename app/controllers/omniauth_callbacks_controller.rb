class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def stripe_connect
    binding.pry
    # Make a post request to Stripe to retrieve the account id
    # https://stripe.com/docs/connect/standard-accounts#token-request
    # Store account id on community
  end
end

# curl https://connect.stripe.com/oauth/token \
#   -d client_secret=sk_test_12K0UzcUDYsKP5AkrCxIeMKy00tDWbm8o0 \
#   -d code="ac_FTiyFerGlA30A5pjWE80NJSjMaDDCRXA" \
#   -d grant_type=authorization_code