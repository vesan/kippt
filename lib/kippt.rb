require "kippt/version"
require "faraday"
require "faraday_middleware"
require "kippt/client"

module Kippt
  class APIError < StandardError; end
end
