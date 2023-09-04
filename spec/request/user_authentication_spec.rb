describe "User Authentication", type: :request do
  context "when the user is logged in" do 
    it "it can get the root path" do
      sign_in("example-shop.myshopify.com") 
      
      get root_path

      expect(response.body).to include(" Welcome! This is a sample app to view the Order data from your Shopify store.")
      expect(response.body).to include("example-shop.myshopify.com")
    end

    it "can get the orders path" do
      sign_in("example-shop.myshopify.com") 

      get orders_path

      expect(response.body).to include("Get data")
      expect(response.body).to include("example-shop.myshopify.com")
    end
  end

  context "when the user is not logged in" do
    it "cannot get the root path" do
      get root_path

      expect(response).to redirect_to(login_path)
    end

    it "cannot get the orders path" do
      get orders_path

      expect(response).to redirect_to(login_path)
    end
  end
end