module Shopify
  module Orders
    class NetSalesByProduct < DataFetch
      private
    
      def fetch_data
        @temp_hash = Hash.new { |hash, key| hash[key] = { "net_sales" => 0.0, "product_name" => '' } }
        net_sales_by_product = []
        
        orders = ShopifyAPI::Order.all(
          session: @session, 
          created_at_min: @date.beginning_of_day.iso8601,
          created_at_max: @date.end_of_day.iso8601,
          limit: 250
        )
    
        loop do
          build_net_sales_hash(orders)
          break unless ShopifyAPI::Product.next_page?
    
          orders = ShopifyAPI::Order.all(
            session: @session, 
            created_at_min: @date.beginning_of_day.iso8601,
            created_at_max: @date.end_of_day.iso8601,
            limit: 250,
            page_info: ShopifyAPI::Product.next_page_info
          )
        end
    
        @temp_hash.each do |product_id, data|
          net_sales_by_product << { "product_id" => product_id, "product_name" => data["product_name"], "net_sales" => data["net_sales"] }
        end
      
        net_sales_by_product
      end
    
      def build_net_sales_hash(orders)    
        orders.each do |order|
          order.line_items.each do |line_item|
            product_id = line_item["id"]
            product_name = line_item["name"]
            product_total = line_item["price"].to_f * line_item["quantity"].to_i
      
            @temp_hash[product_id]["net_sales"] += product_total
            @temp_hash[product_id]["product_name"] = product_name
          end
        end
      end
    end
  end
end
