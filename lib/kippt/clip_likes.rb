require_relative "read_collection_resource"

# For fetching clip's likes.
class Kippt::ClipLikes
  include Kippt::ReadCollectionResource

  attr_reader :clip

  def initialize(client, clip)
    @client = client
    @clip   = clip
  end

  def self.valid_filter_parameters
    [:limit, :offset]
  end

  def object_class
    Kippt::User
  end

  def collection_class
    Kippt::UserCollection
  end

  def base_uri
    "clips/#{clip.id}/likes"
  end
end
