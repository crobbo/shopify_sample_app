class OrdersController < ApplicationController
  def index 
    shop =  Shop.find_by(store_url: cookies["shopify_app_session"].split("_").first)
  
    session = ShopifyAPI::Auth::Session.new(
      shop: shop.store_url,
      access_token: shop.access_token,
    )

    client = ShopifyAPI::Clients::Rest::Admin.new(session: session)

    response = client.get(path: "orders")

    @data = response.body
  end
end