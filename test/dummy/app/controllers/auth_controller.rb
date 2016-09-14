class AuthController < RailsAdmin::OmniauthController
  def authorized?(email)
    return email =~ /@offerista\.com/
  end
end
