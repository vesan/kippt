require "ostruct"

class Kippt::List
  extend Forwardable

  attr_reader :attributes

  def_delegators :attributes, :rss_url, :updated, :title,
                 :created, :slug, :id, :resource_uri

  def initialize(attributes)
    @attributes = OpenStruct.new(attributes)
  end
end
