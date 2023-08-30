module Shopify
  class DataFetch
    def initialize(context)
      @session = context.session
    end

    def call
      fetch_data
    end
  end
end