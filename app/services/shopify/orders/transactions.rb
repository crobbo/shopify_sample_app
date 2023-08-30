module Shopify
  module Orders
    class Transactions < DataFetch
      private
          
      def fetch_data
        @temp_hash = Hash.new { |hash, key| hash[key] = { "payments_received" => 0.0 } }
        payments_by_gateway = []
        
        orders = ShopifyAPI::Order.all(
          session: @session, 
          created_at_min: @date.beginning_of_day.iso8601,
          created_at_max: @date.end_of_day.iso8601,
          limit: 250
        )
    
        loop do
          build_transactions_hash(orders)
          break unless ShopifyAPI::Product.next_page?
    
          orders = ShopifyAPI::Order.all(
            session: @session, 
            created_at_min: @date.beginning_of_day.iso8601,
            created_at_max: @date.end_of_day.iso8601,
            limit: 250,
            page_info: ShopifyAPI::Product.next_page_info
          )
        end
    
        @temp_hash.each do |gateway, data|
          payments_by_gateway << { "gateway" => gateway, "payments_received" => data["payments_received"] }
        end
      
        payments_by_gateway
      end

      def build_transactions_hash(orders)    
        orders.each do |order|
          transactions = ShopifyAPI::Transaction.all(order_id: order.id, session: @session)

          transactions.each do |transaction|
            next unless transaction.kind == "sale"

            gateway = transaction.gateway
            amount = transaction.amount.to_f

            @temp_hash[gateway]["payments_received"] += amount
          end
        end
      end
    end
  end
end
