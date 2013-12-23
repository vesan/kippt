class Kippt::LikeCollection
  include Kippt::Collection

  def object_class
    Kippt::Like
  end

  def collection_resource_class
    Kippt::Likes
  end
end
