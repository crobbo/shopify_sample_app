describe "User Authentication", type: :system do
  context "when the store url is invalid" do
    it "it does not allow login", js: true, chrome: true do
      # trys with invalid url
      visit root_path
      fill_in "Your Shopify Store Domain:", with: "sada-store.myshosdapify.caom"
      click_on "Log in with Shopify"
      expect(page).to have_content("Please enter a valid store url")

      # trys with valid url but the store does not exist
      visit root_path
      fill_in "Your Shopify Store Domain:", with: "sadasadjkadkjsa-sdasdasdstore.myshopify.com"
      click_on "Log in with Shopify"
      expect(page).to have_content("Sorry, this shop is currently unavailable.") 

      # Logs in with emptry string
      visit root_path
      fill_in "Your Shopify Store Domain:", with: ""
      click_on "Log in with Shopify"
      expect(page).to have_content("Please enter a valid store url")
    
      # domain has http:// in front of it. Test it doesn't throw an error
      visit root_path
      fill_in "Your Shopify Store Domain:", with: "http://example-shop.myshopify.com"
      click_on "Log in with Shopify"
      expect(page).to have_content("Sorry, this shop is currently unavailable.")

      # domain has https:// in front of it. Testing it doesn't throw an error
      visit root_path
      fill_in "Your Shopify Store Domain:", with: "https://example-shop.myshopify.com"
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