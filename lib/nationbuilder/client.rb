# frozen_string_literal: true

class NationBuilder::Client
  REQUIRED_ATTRIBUTES = %i[slug token refresh_token token_expires_at].freeze

  def initialize(nation, options = {})
    REQUIRED_ATTRIBUTES.each do |attribute|
      next if nation[attribute].present?

      raise ArgumentError, "NationBuilder::Client nation must respond to #{attribute}"
    end

    slug = nation[:slug]
    token = nation[:token]
    refresh_token = nation[:refresh_token]
    token_expires_at = nation[:token_expires_at]

    @options = options

    @nation = {
      slug:,
      token:,
      refresh_token:,
      token_expires_at:
    }
  end

  def call(path, action, body = {})
    url = NationBuilder::Utils::UrlBuilder.call(@nation, path)
    response = HTTParty.send(
      url,
      action,
      body: body,
      headers: {Accept: "application/json", "Content-type": "application/json"}.merge(@options.fetch(:headers, {})),
      timeout: @options.fetch(:timeout, 30),
      uri_adapter: @options.fetch(:uri_adapter, Addressable::URI)
    )

    response_body = JSON.parse(response.body || "{}")

    if response.success?
      {status: response_status(response.code), code: response.code, body: response_body}
    elsif response.code == 429 && response.headers["retry-after"].present?
      sleep(response.headers["retry-after"].to_i + 1)
      NbApiRequest.call(@nation, @action, @path, @body)
    elsif expired_token_error?(response_body) && @nation.refresh_oauth_token
      NbApiRequest.call(@nation, @action, @path, @body)
    else
      raise OAuth2::Error.new(response)
    end
  end

  private

  def response_status(code)
    case code
    when 200, 201, 202, 204
      :success
    when 301, 302, 303, 307, 308
      :redirect
    when 404
      :not_found
    when 400, 401, 403, 409, 422
      :server_error
    when 500, 502, 503, 504
      :application_error
    else
      :unknown
    end
  end

  def expired_token_error?(response_body)
    ["token_expired", "invalid_grant"].include?(response_body.fetch("code", ""))
  end
end
