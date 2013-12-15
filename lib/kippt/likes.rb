require_relative "user_collection"
require_relative "like"

class Kippt::Likes
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
    Kippt::User
  end

  def collection_class
    Kippt::UserCollection
  end

  def base_uri
    "clips/#{clip.id}/likes"
  end

  def fetch(options = {})
    validate_collection_options(options)

    if options.empty? && @clip.all_likes_embedded?
      collection_class.new({"objects" => @clip.likes_data}, client)
    else
      collection_class.new(client.get(base_uri, options).body, client)
    end
  end

  alias all fetch

  def build
    Kippt::Like.new(client, clip)
  end

  def destroy_resource(resource)
    client.delete(base_uri).success?
  end
end
