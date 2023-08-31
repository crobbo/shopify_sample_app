describe DataFetcher do
  let!(:json) do
    file_fixture("orders_sample_response.json").read
  end
  
  context "net sales by product" do
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
            "net_sales"=>398.0,
            "product_id"=>518995019,
            "product_name"=>"IPod Nano - 8gb - red"
          },
          {
            "net_sales"=>398.0,
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
    before do
      stub_request(:get, "https://example.com/admin/api/2023-07/orders.json?created_at_max=#{Date.current.strftime("%Y-%m-%d")}T23:59:59Z&created_at_min=#{Date.current.strftime("%Y-%m-%d")}T00:00:00Z&limit=250")
        .to_return(body: json)
    end

    it "returns an array of hashes" do
      session = ShopifyAPI::Auth::Session.new(shop: "example.com", access_token: "token123")
      service = DataFetcher.call(Date.current, session, :total_taxes)

      expect(service.first).to eq (23.88)
      expect(service.second).to eq (["Total Taxes"])
      expect(service.third).to eq (["total_taxes"])
    end
  end

  context "order transactions" do
    before do
      stub_request(:get, "https://example.com/admin/api/2023-07/orders.json?created_at_max=#{Date.current.strftime("%Y-%m-%d")}T23:59:59Z&created_at_min=#{Date.current.strftime("%Y-%m-%d")}T00:00:00Z&limit=250")
        .to_return(body: json)

      stub_request(:get, "https://example.com/admin/api/2023-07/orders/450789469/transactions.json")
        .to_return(body: file_fixture("transaction_sample_response_450789469.json").read)

      stub_request(:get, "https://example.com/admin/api/2023-07/orders/450789470/transactions.json")
        .to_return(body: file_fixture("transaction_sample_response_450789470.json").read)
    end

    it "returns an array of hashes" do
      session = ShopifyAPI::Auth::Session.new(shop: "example.com", access_token: "token123")
      service = DataFetcher.call(Date.current, session, :order_transactions)

      expect(service.first).to eq ([
        {
          "gateway"=>"shopify_payments",
          "payments_received"=> 597.0
        },
        {
          "gateway"=>"paypal",
          "payments_received"=> 597.0
        }
      ])
      expect(service.second).to eq (["Gateway", "Payments Received"])
      expect(service.third).to eq (["gateway", "payments_received"])
    end
  end

  context "payout fees" do
    let(:json) do
      file_fixture("payouts_sample_response.json").read
    end

    before do
      stub_request(:get, "https://example.com/admin/api/2023-07/shopify_payments/payouts.json?date_max=#{Date.current.strftime("%Y-%m-%d")}T00:00:00Z&date_min=#{Date.current.strftime("%Y-%m-%d")}T23:59:59Z&limit=250")
        .to_return(body: json)
    end

    it "returns an array of hashes" do
      session = ShopifyAPI::Auth::Session.new(shop: "example.com", access_token: "token123")
      service = DataFetcher.call(Date.current, session, :payout_fees)

      expect(service.first).to eq ([{"gateway"=>"shopify_payments", "fee_payouts"=> 19.66}])
      expect(service.second).to eq (["Gateway", "Fee Payouts"])
      expect(service.third).to eq (["gateway", "fee_payouts"])
    end
  end

   context "liabilites" do
    before do
      stub_request(:get, "https://example.com/admin/api/2023-07/orders.json?created_at_max=#{Date.current.strftime("%Y-%m-%d")}T23:59:59Z&created_at_min=#{Date.current.strftime("%Y-%m-%d")}T00:00:00Z&financial_status=paid&limit=250&status=open")
        .to_return(body: json)
    end

    it "returns an array of hashes" do
      session = ShopifyAPI::Auth::Session.new(shop: "example.com", access_token: "token123")
      service = DataFetcher.call(Date.current, session, :liabilities)

      expect(service.first).to eq (598.94)
      expect(service.second).to eq (["Liabilities"])
      expect(service.third).to eq (["liabilities"])
    end
  end

  context "liabilites" do
    before do
      stub_request(:get, "https://example.com/admin/api/2023-07/orders.json?created_at_max=#{Date.current.strftime("%Y-%m-%d")}T23:59:59Z&created_at_min=#{Date.current.strftime("%Y-%m-%d")}T00:00:00Z&limit=250")
        .to_return(body: json)
    end

    it "returns an array of hashes" do
      session = ShopifyAPI::Auth::Session.new(shop: "example.com", access_token: "token123")
      service = DataFetcher.call(Date.current, session, :shipping)

      expect(service.first).to eq (62)
      expect(service.second).to eq (["Shipping"])
      expect(service.third).to eq (["shipping"])
    end
  end

  context "liabilites" do
    before do
      stub_request(:get, "https://example.com/admin/api/2023-07/orders.json?created_at_max=#{Date.current.strftime("%Y-%m-%d")}T23:59:59Z&created_at_min=#{Date.current.strftime("%Y-%m-%d")}T00:00:00Z&limit=250")
        .to_return(body: json)
    end

    it "returns an array of hashes" do
      session = ShopifyAPI::Auth::Session.new(shop: "example.com", access_token: "token123")
      service = DataFetcher.call(Date.current, session, :discounts)

      expect(service.first).to eq (20)
      expect(service.second).to eq (["Discounts"])
      expect(service.third).to eq (["discounts"])
    end
  end
end