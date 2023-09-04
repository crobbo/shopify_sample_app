class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]
  
  def new
  end

  def create 
    store_url = set_store_url

    unless valid_shopify_url?(store_url)
      flash[:error] = "Please enter a valid store url in this format: example-store.myshopify.com"
      redirect_to login_path and return
    end

    auth_response = ShopifyAPI::Auth::Oauth.begin_auth(shop: store_url, redirect_path: "/auth/callback")

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
    session[:shopify_store_url] = nil
    redirect_to login_path, notice: "Successfully logged out."
  end

  private 

  def login_params
    begin
      params.require(:shop)
    rescue
      return nil
    end
  end

  def redirect_if_logged_in
    if valid_cookie_exists
      redirect_to root_path
    end
  end

  def set_store_url
    return ""  unless login_params

    login_params.sub(/^https?:\/\//, '')
  end

  def valid_shopify_url?(url)    
    # Validate the remaining URL with the regular expression
    regex = /\A[\w-]+\.myshopify\.com\z/
    !!regex.match(url)
  end  
end