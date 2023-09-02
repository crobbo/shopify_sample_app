class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]
  
  def new
  end

  def create
    shop = login_params

    auth_response = ShopifyAPI::Auth::Oauth.begin_auth(shop: shop, redirect_path: "/auth/callback")

    cookies[auth_response[:cookie].name] = {
      expires: auth_response[:cookie].expires,
      secure: true,
      http_only: true,
      value: auth_response[:cookie].value
    }

    redirect_to auth_response[:auth_route], allow_other_host: true
  end

  def destroy 
    cookies.delete("shopify_app_session")
    redirect_to login_path, notice: "Successfully logged out."
  end

  private 

  def login_params
    params.require(:shop)
  end

  def redirect_if_logged_in
    if valid_cookie_exists
      redirect_to root_path
    end
  end
end