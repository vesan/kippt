require "kippt/comment_collection"
require "kippt/comment"
require "kippt/comment_collection"

class Kippt::Comments
  include Kippt::CollectionResource

  attr_reader :clip

  def initialize(client, clip)
    @client = client
    @clip   = clip
  end

  def self.valid_filter_parameters
    [:limit, :offset]
  end

  def object_class
    Kippt::Comment
  end

  def collection_class
    Kippt::CommentCollection
  end

  def base_uri
    "clips/#{clip.id}/comments"
  end

  def build(attributes = {})
    object_class.new(attributes, client, clip)
  end
end
