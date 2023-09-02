module Shopify
  module Orders
    class Liabilities < DataFetch
      private
    
      def fetch_data        
        orders = ShopifyAPI::Order.all(
          session: @session, 
          created_at_min: @date.beginning_of_day.iso8601,
          created_at_max: @date.end_of_day.iso8601,
          financial_status: 'paid',
          status: 'open',
          limit: 250
        )

        liabilites = 0.0
    
        loop do
          liabilites += sum_libalities(orders)
          break unless ShopifyAPI::Order.next_page?
    
          orders = ShopifyAPI::Order.all(
            session: @session, 
            created_at_min: @date.beginning_of_day.iso8601,
            created_at_max: @date.end_of_day.iso8601,
            financial_status: 'paid',
            status: 'open',
            limit: 250,
            page_info: ShopifyAPI::Order.next_page_info
          )
        end
  
        liabilites
      end
    
      def sum_libalities(orders) 
        orders.sum do |order|
          next 0 unless order.closed_at.nil?

          order.total_price.to_f 
        end
      end
    end
  end
end
