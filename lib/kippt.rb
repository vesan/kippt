require_relative "kippt/version"
require "faraday"
require "faraday_middleware"

require_relative "kippt/helpers"
require_relative "kippt/resource"
require_relative "kippt/collection_resource"
require_relative "kippt/collection"
require_relative "kippt/user"
require_relative "kippt/client"

module Kippt
  class APIError < StandardError; end
end
