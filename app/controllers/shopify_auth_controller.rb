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

      shop = Shop.find_or_create_by(store_url: auth_result[:session].shop)

      shop.update(
        store_url: auth_result[:session].shop,
        # scope: auth_result[:session][:scope],
        auth_session_id: auth_result[:session].id,
        state: auth_result[:session].state,
        shopify_session_id: auth_result[:session].shopify_session_id,
        access_token: auth_result[:session].access_token,
        expires_at: auth_result[:session].expires.to_datetime,
        is_online: auth_result[:session].online?
      )

      redirect_to root_path, notice: "Logged in!"
    rescue
      redirect_to root_path, notice: "Failed to authenticate"
    end
  end
end