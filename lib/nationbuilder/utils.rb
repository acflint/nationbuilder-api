module NationBuilder::Utils
  module UrlBuilder
    module_function

    def call(nation, path)
      url_string = path.include?("http") ? path : "https://#{nation[:slug]}.nationbuilder.com" + path
      uri = URI.parse(url_string)

      existing_query = URI.decode_www_form(String(uri.query)).to_h
      new_query_ar = existing_query.merge("token" => nation[:token]).to_a
      uri.query = URI.encode_www_form(new_query_ar)

      uri.to_s
    end
  end
end
