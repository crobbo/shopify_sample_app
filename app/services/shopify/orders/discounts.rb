module Shopify
  module Orders
    class Discounts < DataFetch
      private
    
      def fetch_data        
        orders = ShopifyAPI::Order.all(
          session: @session, 
          created_at_min: @date.beginning_of_day.iso8601,
          created_at_max: @date.end_of_day.iso8601,
          limit: 250
        )

        discounts = 0.0
    
        loop do
          discounts += sum_shpping_cost(orders)
          break unless ShopifyAPI::Product.next_page?
    
          orders = ShopifyAPI::Order.all(
            session: @session, 
            created_at_min: @date.beginning_of_day.iso8601,
            created_at_max: @date.end_of_day.iso8601,
            limit: 250,
            page_info: ShopifyAPI::Product.next_page_info
          )
        end
  
        discounts
      end
    
      def sum_shpping_cost(orders) 
        orders.sum do |order|
          next 0 if order.financial_status != 'paid'
          
          order.total_discounts.to_f 
        end
      end
    end
  end
end
