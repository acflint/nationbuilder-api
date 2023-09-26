module NationBuilder::Utils
  module UrlBuilder
    module_function

    def call(nation, path)
      url_string = path.include?("http") ? path : "https://#{nation[:slug]}.nationbuilder.com" + path
      uri = URI.parse(url_string)
      new_query_ar = URI.decode_www_form(String(uri.query)) << ["token", nation[:token]]
      uri.query = URI.encode_www_form(new_query_ar)

      uri.to_s
    end
  end
end
