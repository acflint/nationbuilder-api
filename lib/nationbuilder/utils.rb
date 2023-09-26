module NationBuilder::Utils
  module UrlBuilder
    module_function

    def initialize(nation, path)
      @nation = nation
      @path = path
    end

    def url
      url_string = @path.include?("http") ? @path : @nation.url + @path

      uri = URI.parse(url_string)
      new_query_ar = URI.decode_www_form(String(uri.query)) << ["access_token", @nation.token]
      uri.query = URI.encode_www_form(new_query_ar)

      uri.to_s
    end
  end
end
