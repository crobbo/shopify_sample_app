# app/services/tweet_creator.rb
module Shopify
  class Orders
    class TotalTaxes < Orders
      def initialize(context)
        @date = context.date
        @session = context.session
      end

      # Assumes all orders are in USD. If not, this will need to be updated. 

      private
    
      def fetch_data        
        orders = ShopifyAPI::Order.all(
          session: @session, 
          created_at_min: @date.beginning_of_day.iso8601,
          created_at_max: @date.end_of_day.iso8601,
          limit: 250
        )

        total_taxes = 0.0
    
        loop do
          total_taxes += sum_total_taxes(orders)
          break unless ShopifyAPI::Product.next_page?
    
          orders = ShopifyAPI::Order.all(
            session: @session, 
            created_at_min: @date.beginning_of_day.iso8601,
            created_at_max: @date.end_of_day.iso8601,
            limit: 250,
            page_info: ShopifyAPI::Product.next_page_info
          )
        end
  
        total_taxes
      end
    
      def sum_total_taxes(orders) 
        sum = 0
        orders.each do |order|
          order.line_items.each do |line_item|
            line_item["tax_lines"].each do |tax_line|
              sum += tax_line["price"].to_f
            end
          end
        end
        sum
      end
    end
  end
end
