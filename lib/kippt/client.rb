require "kippt/connection"
require "kippt/account"
require "kippt/clips"
require "kippt/lists"
require "kippt/users"

class Kippt::Client
  include Kippt::Connection

  attr_reader :username, :token, :password

  def initialize(options = {})
    if options[:unauthenticated]
      # Unauthenticated
    else
      @username = options.fetch(:username) { raise ArgumentError.new("username is required") }

      @password = options.fetch(:password) { nil }
      @token    = options.fetch(:token) { nil }

      if @password.nil? && @token.nil?
        raise ArgumentError.new("password or token is required")
      end
    end
  end

  def account
    Kippt::Account.new(get("account").body)
  end

  def lists
    Kippt::Lists.new(self)
  end

  def clips
    Kippt::Clips.new(self)
  end

  def users
    Kippt::Users.new(self)
  end

  def collection_resource_for(resource_class)
    resource_class.new(self)
  end

  def resource_from_url(resource_class, url)
    raise ArgumentError.new("The parameter URL can't be blank") if url.nil? || url == ""

    resource_class.new(self.get(url).body, self)
  end
end
