class OrdersController < ApplicationController
  def index 
    shop =  Shop.find_by(store_url: cookies["shopify_app_session"].split("_").first)
  
    session = ShopifyAPI::Auth::Session.new(
      shop: shop.store_url,
      access_token: shop.access_token,
    )

    if params["date(1i)"] && params["date(2i)"] && params["date(3i)"]
      date = DateTime.parse("#{params["date(1i)"]}-#{params["date(2i)"]}-#{params["date(3i)"]}")

      @data_object = DataFetcher.call(date, session, "net_sales_by_product")
      @data = @data_object.first
      @table_headers = @data_object.second
      @table_row_keys = @data_object.third
    end
  end
end