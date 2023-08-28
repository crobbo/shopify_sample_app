# app/services/tweet_creator.rb
class DataFetcher < ApplicationService
  def initialize(date, session, fetch_method)
    @date = date
    @session = session
    @fetch_method = fetch_method
  end

  def call
    [send(@fetch_method), table_headers[@fetch_method], table_row_keys[@fetch_method]]
  end

  private

  def client 
    @client ||= ShopifyAPI::Clients::Rest::Admin.new(session: @session)
  end

  def table_headers 
    {
      "net_sales_by_product" => ["Product Name", "Product ID", "Net Sales By Day"]
    }.freeze
  end

  def table_row_keys
    {
      "net_sales_by_product" => ["product_name", "product_id", "net_sales"]
    }.freeze
  end

  def net_sales_by_product
    temp_hash = Hash.new { |hash, key| hash[key] = { "net_sales" => 0.0, "product_name" => '' } }
    net_sales_by_product = []
    
    response = client.get(path: "orders", query: { created_at_min: @date.beginning_of_day.iso8601, created_at_max: @date.end_of_day.iso8601 })
    
    response.body["orders"].each do |order|
      order["line_items"].each do |line_item|
        product_id = line_item["id"]
        product_name = line_item["name"]
        product_total = line_item["price"].to_f * line_item["quantity"].to_i
        
        temp_hash[product_id]["net_sales"] += product_total
        temp_hash[product_id]["product_name"] = product_name
      end
    end
    
    temp_hash.each do |product_id, data|
      net_sales_by_product << { "product_id" => product_id, "product_name" => data["product_name"], "net_sales" => data["net_sales"] }
    end
  
    net_sales_by_product
  end
end