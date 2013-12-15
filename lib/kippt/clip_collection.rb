require_relative "collection"
require_relative "clip"

class Kippt::ClipCollection
  include Kippt::Collection

  def object_class
    Kippt::Clip
  end

  def collection_resource_class
    Kippt::Clips
  end
end
