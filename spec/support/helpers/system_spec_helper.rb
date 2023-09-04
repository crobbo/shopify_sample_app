module Helpers
  module SystemSpecHelper
    def sign_in(store_url)
      Shop.create(store_url: store_url)
      page.set_rack_session(shopify_store_url: store_url)
      create_cookie("shopify_app_session", "#{store_url}_1234567890abcdefg", :domain => "localhost")
    end
  end
end
