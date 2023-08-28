class OrdersController < ApplicationController
  def index 
    shop =  Shop.find_by(store_url: cookies["shopify_app_session"].split("_").first)
  
    session = ShopifyAPI::Auth::Session.new(
      shop: shop.store_url,
      access_token: shop.access_token,
    )

    client = ShopifyAPI::Clients::Rest::Admin.new(session: session)

    # extract this logic to a service object
    if params["date(1i)"] && params["date(2i)"] && params["date(3i)"]
      # do something
      year = params["date(1i)"] 
      month = params["date(2i)"] 
      day = params["date(3i)"] 

      start_date = DateTime.parse("#{year}-#{month}-#{day}").beginning_of_day.iso8601
      end_date = DateTime.parse("#{year}-#{month}-#{day}").end_of_day.iso8601
    end

    response = client.get(path: "orders", query: { created_at_min: start_date, created_at_max: end_date })


    @net_sales_by_product = Hash.new { |hash, key| hash[key] = { "net_sales" => 0.0, "product_name" => '' } }

    response.body["orders"].each do |order|
      order["line_items"].each do |line_item|
        product_id = line_item["id"]
        product_name = line_item["name"]  # Assumes the key for the product name is "name"
        product_total = line_item["price"].to_f * line_item["quantity"].to_i
    
        @net_sales_by_product[product_id]["net_sales"] += product_total
        @net_sales_by_product[product_id]["product_name"] = product_name
      end
    end
  end
end