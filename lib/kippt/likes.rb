# This class is only meant to be used by Kippt::Like class for liking and
# unliking clips.
class Kippt::Likes
  include Kippt::CollectionResource

  attr_reader :clip

  def initialize(client, clip)
    @client = client
    @clip   = clip
  end

  def base_uri
    "clips/#{clip.id}/likes"
  end

  def destroy_resource(resource)
    client.delete(base_uri).success?
  end
end
