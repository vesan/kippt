require_relative "lists"
require_relative "list"

class Kippt::ListCollection
  include Kippt::Collection

  def object_class
    Kippt::List
  end

  def collection_resource_class
    Kippt::Lists
  end
end
