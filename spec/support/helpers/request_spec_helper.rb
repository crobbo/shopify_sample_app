module Helpers
  module RequestSpecHelper
    def sign_in(store_url)
      Shop.create(store_url: store_url)
      cookies[:shopify_app_session] = "#{store_url}_1234567890abcdefg"
      set_session({ shopify_store_url: "#{store_url}" })
    end
  end
end

