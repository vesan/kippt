require "kippt/collection"
require "kippt/list"

class Kippt::ListCollection
  include Kippt::Collection

  def object_class
    Kippt::List
  end
end
