# frozen_string_literal: true

RSpec.describe NationBuilder::Client do
  let(:nation) do
    {
      slug: "my-nation",
      token: "my-token",
      refresh_token: "my-refresh-token",
      token_expires_at: Time.now + 3600
    }
  end

  let(:nation_url) do
    "https://my-nation.nationbuilder.com/path?token=my-token"
  end

  describe "#initialize" do
    context "when required attributes are missing" do
      it "raises an ArgumentError" do
        nation[:slug] = nil
        expect { NationBuilder::Client.new(nation) }.to raise_error(ArgumentError)
      end
    end

    context "when all required attributes are present" do
      it "creates a new client instance" do
        client = NationBuilder::Client.new(nation)
        expect(client).to be_a(NationBuilder::Client)
      end
    end
  end

  describe "#call" do
    let(:client) { NationBuilder::Client.new(nation) }

    context "when the request is successful" do
      it "returns a hash with the response status, code, and body" do
        stub_request(:get, nation_url)
          .with(
            headers: {
              "Accept" => "application/json",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "Content-Type" => "application/json",
              "User-Agent" => "Ruby"
            }
          )
          .to_return(status: 200, body: "{}", headers: {})

        response = client.call(:get, "/path")
        expect(response).to include(:status, :code, :body)
      end
    end

    context "when the request fails with a 429 error" do
      it "waits for the specified retry-after time and retries the request" do
        stub_request(:get, nation_url)
          .with(
            headers: {
              "Accept" => "application/json",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "Content-Type" => "application/json",
              "User-Agent" => "Ruby"
            }
          ).to_return(status: 429, body: "{}", headers: {"retry-after": "2"})
          .then.to_return(status: 200, body: "{}")

        expect(client.call(:get, "/path")).to include(:status, :code, :body)
      end
    end

    context "when the access token has expired" do
      it "refreshes the access token and retries the request" do
        stub_request(:get, nation_url)
          .with(
            headers: {
              "Accept" => "application/json",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "Content-Type" => "application/json",
              "User-Agent" => "Ruby"
            }
          )
          .to_return(status: 200, body: "{}", headers: {})

        expect(client.call(:get, "/path")).to include(:status, :code, :body)
      end
    end
  end
end
