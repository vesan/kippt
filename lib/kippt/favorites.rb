# This class is only meant to be used by Kippt::Favorite class for favoriting
# and unfavoriting clips.
class Kippt::Favorites
  include Kippt::CollectionResource

  attr_reader :clip

  def initialize(client, clip)
    @client = client
    @clip   = clip
  end

  def base_uri
    "clips/#{clip.id}/favorites"
  end

  def destroy_resource(resource)
    client.delete(base_uri).success?
  end
end
