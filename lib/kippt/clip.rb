require "ostruct"

class Kippt::Clip
  extend Forwardable

  attr_reader :attributes

  def_delegators :attributes, :url_domain, :updated, :is_starred, :title,
                :url, :notes, :created, :list, :id, :resource_uri, 
                :is_starred=, :title=, :url=, :notes=, :list=

  def initialize(attributes = {}, collection_resource = nil)
    @attributes = OpenStruct.new(attributes)
    @collection_resource   = collection_resource
  end

  def save
    @collection_resource.save_object(self)
  end
end
