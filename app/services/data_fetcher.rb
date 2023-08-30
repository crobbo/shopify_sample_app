class DataFetcher < ApplicationService
  def initialize(date, session, data_type)
    @date = date
    @session = session
    @data_type = data_type
  end

  attr_reader :date, :session

  SHOPIFY_DATA = {
    net_sales_by_product: Shopify::Orders::NetSalesByProduct,
    total_taxes: Shopify::Orders::TotalTaxes,
    order_transactions: Shopify::Orders::Transactions
  }

  def call
    [SHOPIFY_DATA[@data_type].new(self).call, table_headers[@data_type], table_row_keys[@data_type]]
  end

  private

  def table_headers 
    {
      net_sales_by_product: ["Product Name", "Product ID", "Net Sales By Day"],
      total_taxes: ["Total Taxes"],
      order_transactions: ["Gateway", "Payments Received"]
    }.freeze
  end

  def table_row_keys
    {
      net_sales_by_product: ["product_name", "product_id", "net_sales"],
      total_taxes: ["total_taxes"],
      order_transactions: ["gateway", "payments_received"]
    }.freeze
  end
end