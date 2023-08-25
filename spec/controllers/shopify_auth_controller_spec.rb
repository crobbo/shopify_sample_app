describe ShopifyAuthController, type: :controller do
  describe '#callback' do
    let(:fake_auth_result) do
      {
        session: OpenStruct.new(access_token: 'access_token', shop: 'test.myshopfy.com'),
        cookie: OpenStruct.new(name: 'cookie_name', expires: Time.now + 3600, value: 'cookie_value')
      }
    end

    let(:fake_auth_query) do
      instance_double("ShopifyAPI::Auth::Oauth::AuthQuery", 
                      code: 'fake_code', 
                      shop: 'fake_shop', 
                      timestamp: 'fake_timestamp', 
                      state: 'fake_state', 
                      host: 'fake_host', 
                      hmac: 'fake_hmac')
    end

    before do
      allow(ShopifyAPI::Auth::Oauth).to receive(:validate_auth_callback).and_return(fake_auth_result)
      allow(ShopifyAPI::Auth::Oauth::AuthQuery).to receive(:new).and_return(fake_auth_query)
    end

    it 'validates the OAuth callback and sets the cookie' do
      expect(Shop.count).to eq 0

      post :callback, params: {
        code: 'fake_code',
        shop: 'fake_shop',
        timestamp: 'fake_timestamp',
        state: 'fake_state',
        host: 'fake_host',
        hmac: 'fake_hmac'
      }

      expect(cookies[fake_auth_result[:cookie].name]).to eq(fake_auth_result[:cookie].value)
      expect(Shop.count).to eq 1
      expect(response).to redirect_to(root_path)
    end
  end
end
