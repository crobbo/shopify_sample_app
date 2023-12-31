module Shopify
  module ShopifyPayments
    # limited to shopify payment processor
    class Payouts < DataFetch
      private
          
      def fetch_data
        @temp_hash = Hash.new { |hash, key| hash[key] = { "fee_payouts" => 0.0 } }
        fee_adjustments_by_gateway = []
        
        puts "#{@date.iso8601}"

        puts "Fetching payouts..."

        payouts = ShopifyAPI::Payout.all(
          session: @session, 
          # date_min: @date.beginning_of_day.iso8601,
          # date_max: (@date + 1.day).beginning_of_day.iso8601,
          limit: 250
        )
        
    
        loop do
          build_payout_hash(payouts)
          break unless ShopifyAPI::Payout.next_page?
    
          payouts = ShopifyAPI::Payout.all(
            session: @session, 
            # date_min: @date.beginning_of_day.iso8601,
            # date_max: (@date + 1.day).beginning_of_day.iso8601,
            limit: 250
          )
          
        end
    
        @temp_hash.each do |payment_processor, data|
          fee_adjustments_by_gateway << { "gateway" => payment_processor, "fee_payouts" => data["fee_payouts"] }
        end
      
        fee_adjustments_by_gateway
      end

      def build_payout_hash(payouts)    
        payouts.each do |payout|
          amount = payout.summary["charges_fee_amount"].to_f
            
          @temp_hash["shopify_payments"]["fee_payouts"] += amount      
        end
      end
    end
  end
end
