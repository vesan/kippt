require_relative "list_collection"
require_relative "list"

class Kippt::Lists
  include Kippt::CollectionResource

  def initialize(client)
    @client = client
  end

  def self.valid_filter_parameters
    [:limit, :offset]
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
