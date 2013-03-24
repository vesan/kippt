require "kippt/connection"
require "kippt/account"
require "kippt/clips"
require "kippt/lists"
require "kippt/users"

class Kippt::Client
  include Kippt::Connection

  attr_reader :username, :token, :password

  def initialize(options = {})
    @username = options.fetch(:username) { raise ArgumentError.new("username is required") }

    @password = options.fetch(:password) { nil }
    @token    = options.fetch(:token) { nil }

    if @password.nil? && @token.nil?
      raise ArgumentError.new("password or token is required")
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
end
