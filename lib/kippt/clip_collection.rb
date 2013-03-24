require "kippt/collection"
require "kippt/clip"

class Kippt::ClipCollection
  include Kippt::Collection

  def object_class
    Kippt::Clip
  end

  def collection_resource_class
    Kippt::Clips
  end
end
