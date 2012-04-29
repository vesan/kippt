require "kippt/version"
require "core_ext/open_struct"
require "faraday"
require "faraday_middleware"
require "kippt/client"

module Kippt
  class APIError < StandardError; end
end
