require "json_web_token"

module Request
  module JsonHelpers
    def json_response
      @json_resonse ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  module HeadersHelpers
    def api_header(version = 1)
      request.headers["Accept"] = "application/vnd.marketplace.v#{version}"
    end

    def api_authorization_header(user)
      payload = {
        email: user.email,
        id: user.id
      }
      request.headers["Authorization"] = JsonWebToken.encode payload
    end

    def api_response_format(format = Mime::JSON)
      request.headers["Accept"] = "#{request.headers['Accept']},#{format}"
      request.headers["Content-Type"] = format.to_s
    end

    def include_default_accept_headers
      api_header
      api_response_format
    end
  end
end