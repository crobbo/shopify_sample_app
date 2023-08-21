class ShopifyAuthController < ApplicationController
  def callback
    begin
      auth_result = ShopifyAPI::Auth::Oauth.validate_auth_callback(
        cookies: cookies.to_h,
        auth_query: ShopifyAPI::Auth::Oauth::AuthQuery.new(
          code: params[:code], 
          shop: params[:shop], timestamp: params[:timestamp], 
          state: params[:state],
          host: params[:host],
          hmac: params[:hmac]
        ),
      )
  
      cookies[auth_result[:cookie].name] = {
        expires: auth_result[:cookie].expires,
        secure: true,
        http_only: true,
        value: auth_result[:cookie].value
      }
  
      redirect_to root_path, notice: "Logged in!"
    rescue
      redirect_to root_path, notice: "Failed to authenticate"
    end
  end
end