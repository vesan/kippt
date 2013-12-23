require_relative "connection"
require_relative "root_clips"
require_relative "lists"
require_relative "users"

class Kippt::Client
  include Kippt::Connection

  attr_reader :username, :token, :password

  def initialize(options = {})
    self.debug = options.fetch(:debug, nil)

    if options[:unauthenticated]
      # Unauthenticated
    else
      @username  = options.fetch(:username) { raise ArgumentError.new("username is required") }

      @password  = options.fetch(:password) { nil }
      @token     = options.fetch(:token) { nil }

      if @password.nil? && @token.nil?
        raise ArgumentError.new("password or token is required")
      end
    end
  end

  def debug=(value)
    @debug = value
  end

  def debug
    if @debug.nil?
      !!ENV["DEBUG"]
    else
      @debug
    end
  end
  alias_method :debug?, :debug

  def account(include_api_token = false)
    if include_api_token
      url = "account?include_data=api_token"
    else
      url = "account"
    end
    Kippt::User.new(get(url).body, self)
  end

  def lists
    Kippt::Lists.new(self)
  end

  def clips
    Kippt::RootClips.new(self)
  end

  def users
    Kippt::Users.new(self)
  end

  def collection_resource_for(resource_class, *options)
    resource_class.new(*(options + [self]))
  end

  def resource_from_url(resource_class, url)
    raise ArgumentError.new("The parameter URL can't be blank") if url.nil? || url == ""

    resource_class.new(self.get(url).body, self)
  end
end
