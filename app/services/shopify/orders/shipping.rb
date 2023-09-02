module Shopify
  module Orders
    class Shipping < DataFetch
      private
    
      def fetch_data        
        orders = ShopifyAPI::Order.all(
          session: @session, 
          created_at_min: @date.beginning_of_day.iso8601,
          created_at_max: @date.end_of_day.iso8601,
          limit: 250
        )

        shipping_cost = 0.0
    
        loop do
          shipping_cost += sum_shpping_cost(orders)
          break unless ShopifyAPI::Order.next_page?
    
          orders = ShopifyAPI::Order.all(
            session: @session, 
            created_at_min: @date.beginning_of_day.iso8601,
            created_at_max: @date.end_of_day.iso8601,
            limit: 250,
            page_info: ShopifyAPI::Order.next_page_info
          )
        end
  
        shipping_cost
      end
    
      def sum_shpping_cost(orders) 
        orders.sum do |order|
          order.total_shipping_price_set["shop_money"]["amount"].to_f 
        end
      end
    end
  end
end
