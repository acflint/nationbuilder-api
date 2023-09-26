RSpec.describe NationBuilder::Utils::UrlBuilder do
  describe ".call" do
    let(:nation) { {slug: "my-nation", token: "my-token"} }

    context "when given a path with no query parameters" do
      let(:path) { "/my-path" }

      it "returns a URL with the nation slug and token as query parameters" do
        expect(described_class.call(nation, path)).to eq("https://my-nation.nationbuilder.com/my-path?token=my-token")
      end
    end

    context "when given a path with existing query parameters" do
      let(:path) { "/my-path?existing_param=value" }

      it "returns a URL with the nation slug and token as query parameters, preserving the existing parameters" do
        expect(described_class.call(nation, path)).to eq("https://my-nation.nationbuilder.com/my-path?existing_param=value&token=my-token")
      end
    end

    context "when given a path with an existing token parameter" do
      let(:path) { "/my-path?token=existing-token" }

      it "returns a URL with the nation slug and token as query parameters, overwriting the existing token parameter" do
        expect(described_class.call(nation, path)).to eq("https://my-nation.nationbuilder.com/my-path?token=my-token")
      end
    end

    context "when given a path with a full URL" do
      let(:path) { "https://example.com/my-path" }

      it "returns the same URL, with the token appended to it" do
        expect(described_class.call(nation, path)).to eq("https://example.com/my-path?token=my-token")
      end
    end
  end
end
