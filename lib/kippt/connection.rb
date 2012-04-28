module Kippt::Connection
  def get(url, options = {})
    request(:get, url, options)
  end

  def post(url, options = {})
    request(:post, url, options)
  end

  def put(url, options = {})
    request(:put, url, options)
  end

  private

  def connection
    @connection ||= Faraday.new("https://kippt.com/api") do |builder|
      builder.use Faraday::Request::JSON
      builder.use FaradayMiddleware::ParseJson
      # builder.use Faraday::Response::Logger
      builder.adapter Faraday.default_adapter
    end
  end

  def request(method, url, options)
    response = connection.send(method) do |req|
      if @password
        connection.basic_auth(@username, @password)
      else
        req.headers["X-Kippt-Username"]  = @username
        req.headers["X-Kippt-API-Token"] = @token
      end

      if method == :get
        req.url url, options
      else
        req.url  url
        req.body = options
      end
    end
    
    if response.status == 401
      raise Kippt::APIError.new(response.body["message"])
    end

    response
  end
end
