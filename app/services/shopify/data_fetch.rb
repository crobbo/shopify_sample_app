module Shopify
  class DataFetch
    def initialize(context)
      @date = context.date
      @session = context.session
    end

    def call
      fetch_data
    end
  end
end