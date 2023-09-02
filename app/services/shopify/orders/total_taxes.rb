module Shopify
  module Orders
    class TotalTaxes < DataFetch
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
          break unless ShopifyAPI::Order.next_page?
    
          orders = ShopifyAPI::Order.all(
            session: @session, 
            created_at_min: @date.beginning_of_day.iso8601,
            created_at_max: @date.end_of_day.iso8601,
            limit: 250,
            page_info: ShopifyAPI::Order.next_page_info
          )
        end
  
        total_taxes
      end
    
      def sum_total_taxes(orders) 
        orders.sum do |order|
          next 0 if order.financial_status != 'paid'

          order.line_items.sum do |line_item|
            line_item["tax_lines"].sum do |tax_line|
              tax_line["price"].to_f
            end
          end
        end
      end
    end
  end
end
