class DataValidator < ApplicationService
  def initialize(date, session)
    @date = date
    @session = session
  end

  attr_reader :date, :session

  def call
    validate_data
  end

  private

  def validate_data
    net_sales_by_product = Shopify::Orders::NetSalesByProduct.new(self).call.sum { |product| product["net_sales"] }
    total_taxes = Shopify::Orders::TotalTaxes.new(self).call
    total_discounts = Shopify::Orders::Discounts.new(self).call
    liabilities = Shopify::Orders::Liabilities.new(self).call
    total_payments = Shopify::Orders::Transactions.new(self).call.sum { |gateway| gateway["payments_received"] }

    (net_sales_by_product + total_taxes - total_discounts) + liabilities - total_payments
  end
end