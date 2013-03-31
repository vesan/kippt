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

  def all(options = {})
    validate_collection_options(options)

    if options.empty? && @clip.all_comments_embedded?
      collection_class.new({"objects" => @clip.comments_data}, client)
    else
      collection_class.new(client.get(base_uri, options).body, client)
    end
  end

  def build(attributes = {})
    object_class.new(attributes, client, clip)
  end
end
