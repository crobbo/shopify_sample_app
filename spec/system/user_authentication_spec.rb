describe "User Authentication", type: :system do
  context "when the store url is invalid" do
    it "it does not allow login", js: true, chrome: true do
      visit root_path
      
      # trys with invalid url
      fill_in "Your Shopify Store Domain:", with: "sada-store.myshosdapify.caom"

      click_on "Log in with Shopify"

      expect(page).to have_content("This site can’t be reached")

      visit root_path

      # trys with valid url but the store does not exist
      fill_in "Your Shopify Store Domain:", with: "sadasadjkadkjsa-sdasdasdstore.myshopify.com"
      
      click_on "Log in with Shopify"

      expect(page).to have_content("Sorry, this shop is currently unavailable.") 
    end
  end

   context "when the store url is valid" do
    it "allows login", js: :true do
      visit root_path

      expect(page.current_path).to eq("/login")

      sign_in("example-shop.myshopify.com")

      visit root_path

      expect(page).to have_content("Welcome! This is a sample app to view the Order data from your Shopify store.")
      expect(page).to have_content("example-shop.myshopify.com")
    end
  end
end