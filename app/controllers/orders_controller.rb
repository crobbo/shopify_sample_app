class OrdersController < ApplicationController
  def index 
    shop =  Shop.find_by(store_url: cookies["shopify_app_session"].split("_").first)

    @selected_date = query_params.slice("date(1i)", "date(2i)", "date(3i)")
    @selected_order_data = query_params[:order_data]

    unless shop
      flash[:error] = "Failed to find your store. Please clear browser cookies and try again."
      return
    end
  
    begin
      session = ShopifyAPI::Auth::Session.new(
        shop: shop.store_url,
        access_token: shop.access_token,
      ) 

      if @selected_date["date(1i)"] && @selected_date["date(2i)"] && @selected_date["date(3i)"]
        date = DateTime.parse("#{@selected_date["date(1i)"]}-#{@selected_date["date(2i)"]}-#{@selected_date["date(3i)"]}")

        @data_object = DataFetcher.call(date, session, data_type(@selected_order_data))
        @data = @data_object.first
        @table_headers = @data_object.second
        @table_row_keys = @data_object.third
      end

      flash[:success] = "Successfully fetched requested data."

    rescue
      Rails.logger.error "Failed to fetch requested data."
      flash[:error] = "Failed to fetch requested data. Please try again."
    end
  end

  private 

  def query_params
    params.permit(
      "date(1i)", 
      "date(2i)", 
      "date(3i)",
      :order_data
    )
  end

  def data_type(key)
    hash = {
      "Revenue/Sales": :net_sales_by_product,
      "Taxes": :total_taxes,
      "Payments": :order_transactions,
      "Adjustments": :payout_fees,
      "Liabilities": :liabilities,
      "Other Expenses/Shipping Charges": :shipping,
      "Discounts": :discounts
    }
    hash[key.to_sym]
  end
end