require "ostruct"

class Kippt::Clip
  extend Forwardable

  attr_reader :attributes, :errors

  def_delegators :attributes, :url_domain, :updated, :is_starred, :title,
                :url, :notes, :created, :list, :id, :resource_uri, 
                :is_starred=, :title=, :url=, :notes=, :list=

  def initialize(attributes = {}, collection_resource = nil)
    @attributes = OpenStruct.new(attributes)
    @errors     = []
    @collection_resource   = collection_resource
  end

  def destroy
    @collection_resource.destroy_resource(self)
  end

  def save
    response = @collection_resource.save_object(self)
    if response[:error_message]
      errors << response[:error_message]
    end
    response[:success]
  end
end
