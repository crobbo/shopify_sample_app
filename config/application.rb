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
      api_key: "5dd4a4e771d90bb4cf6386838e04212a",
      api_secret_key: "78eb68550d6c47747c8986247a2f7ec4",
      host: "https://sample-app.robbo.dev",
      scope: "read_orders,read_products",
      is_embedded: false, # Set to true if you are building an embedded app
      api_version: "2022-01", # The version of the API you would like to use
      is_private: false, # Set to true if you have an existing private app
    )
  end
end
