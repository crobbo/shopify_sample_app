require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ShopifySampleApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    ShopifyAPI::Context.setup(
      api_key: Rails.application.credentials.shopify[:api_key],
      api_secret_key: Rails.application.credentials.shopify[:api_secret_key],
      host: Rails.application.credentials.shopify[:host],
      scope: "read_orders,read_products,read_shopify_payments_payouts",
      is_embedded: false, # Set to true if you are building an embedded app
      api_version: "2023-07", # The version of the API you would like to use
      is_private: false, # Set to true if you have an existing private app
    )
  end
end
