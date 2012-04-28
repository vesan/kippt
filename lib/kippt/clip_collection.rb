require "kippt/collection"
require "kippt/clip"

class Kippt::ClipCollection
  include Kippt::Collection

  def object_class
    Kippt::Clip
  end
end
