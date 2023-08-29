describe DataFetcher do
  context "net sales by product" do
    let!(:json) do
      file_fixture("orders_sample_response.json").read
    end

    before do
      stub_request(:get, "https://example.com/admin/api/2023-07/orders.json?created_at_max=#{Date.current.strftime("%Y-%m-%d")}T23:59:59Z&created_at_min=#{Date.current.strftime("%Y-%m-%d")}T00:00:00Z&limit=250")
        .to_return(body: json)
    end

    it "returns an array of hashes" do
      session = ShopifyAPI::Auth::Session.new(shop: "example.com", access_token: "token123")
      service = DataFetcher.call(Date.current, session, :net_sales_by_product)

      expect(service.first).to eq (
        [
          {
            "net_sales"=>398.0,
            "product_id"=>466157049,
            "product_name"=>"IPod Nano - 8gb - green"
          },
          {
            "net_sales"=>199.0,
            "product_id"=>518995019,
            "product_name"=>"IPod Nano - 8gb - red"
          },
          {
            "net_sales"=>199.0,
            "product_id"=>703073504,
            "product_name"=>"IPod Nano - 8gb - black"
          }
        ]
      )
      expect(service.second).to eq (["Product Name", "Product ID", "Net Sales By Day"])
      expect(service.third).to eq (["product_name", "product_id", "net_sales"])
    end
  end

  context "total taxes" do
    let!(:json) do
      file_fixture("orders_sample_response.json").read
    end

    before do
      stub_request(:get, "https://example.com/admin/api/2023-07/orders.json?limit=250")
        .to_return(body: json)
    end

    it "returns an array of hashes" do
      session = ShopifyAPI::Auth::Session.new(shop: "example.com", access_token: "token123")
      service = DataFetcher.call(Date.current, session, :total_taxes)

      expect(service.first).to eq (15.92)
      expect(service.second).to eq (["Total Taxes"])
      expect(service.third).to eq (["total_taxes"])
    end
  end
end