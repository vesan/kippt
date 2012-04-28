require "kippt/connection"
require "kippt/collection_resource"
require "kippt/list_collection"
require "kippt/list"

class Kippt::Lists
  include Kippt::CollectionResource

  def initialize(client)
    @client = client
  end

  def object_class
    Kippt::List
  end

  def collection_class
    Kippt::ListCollection
  end

  def base_uri
    "lists"
  end
end
