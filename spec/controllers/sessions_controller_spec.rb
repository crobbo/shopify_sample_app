# spec/controllers/shopify_auth_controller_spec.rb
describe SessionsController, type: :controller do
  describe '#create' do
    let(:shop) { 'example-shop.myshopify.com' }
    let(:fake_auth_response) {
      {
        auth_route: 'http://localhost:3000/auth/callback',
        cookie: OpenStruct.new(name: 'cookie_name', expires: Time.now + 3600, value: 'cookie_value')
      }
    }

    before do
      allow(ShopifyAPI::Auth::Oauth).to receive(:begin_auth).and_return(fake_auth_response)
    end

    it 'sets the cookie and redirects' do
      post :create, params: { shop: shop }

      expect(cookies[fake_auth_response[:cookie].name]).to eq(fake_auth_response[:cookie].value)
      expect(response).to redirect_to(fake_auth_response[:auth_route])
    end
  end
end
