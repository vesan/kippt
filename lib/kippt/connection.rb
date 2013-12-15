require "multi_json"
require "faraday_middleware/response_middleware"

module Kippt::Connection
  HOST = "kippt.com"

  class ParseMultiJson < FaradayMiddleware::ResponseMiddleware
    define_parser do |body|
      begin
        MultiJson.load(body) unless body.strip.empty?
      rescue MultiJson::DecodeError
        nil
      end
    end
  end

  def get(url, options = {})
    request(:get, url, options)
  end

  def post(url, options = {})
    request(:post, url, options)
  end

  def put(url, options = {})
    request(:put, url, options)
  end

  def delete(url, options = {})
    request(:delete, url, options)
  end

  private

  def connection
    @connection ||= Faraday.new("https://#{HOST}/api") do |builder|
      builder.use Kippt::Connection::ParseMultiJson
      builder.use Faraday::Response::Logger if debug?
      builder.adapter Faraday.default_adapter
    end
  end

  def request(method, url, options)
    if @password
      connection.basic_auth(@username, @password)
    end

    response = connection.send(method) do |req|
      set_default_headers(req)

      unless @password
        if @username && @token
          req.headers["X-Kippt-Username"]  = @username
          req.headers["X-Kippt-API-Token"] = @token
        end
      end

      if method == :get
        req.url url, options
      else
        req.url  url
        req.body = MultiJson.dump(options[:data])
      end
    end

    if response.status == 401 || (500..599).include?(response.status)
      if response.body && response.body["message"]
        raise Kippt::APIError.new(response.body["message"])
      else
        raise Kippt::APIError.new("Unknown response from Kippt: #{response.body}")
      end
    end

    response
  end

  def set_default_headers(req)
    req.headers["Content-Type"] = "application/vnd.kippt.20120429+json"
    app_string = "KipptRubyGem #{Kippt::VERSION},vesa@vesavanska.com,https://github.com/vesan/kippt"
    req.headers["X-Kippt-Client"] = app_string
    req.headers["User-Agent"]     = app_string
  end
end
