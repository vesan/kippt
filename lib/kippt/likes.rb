require "kippt/user_collection"
require "kippt/user"
require "kippt/like"

class Kippt::Likes
  include Kippt::CollectionResource

  attr_reader :clip

  def initialize(client, clip)
    @client = client
    @clip   = clip
  end

  def self.valid_filter_parameters
    []
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

  def all(options = {})
    validate_collection_options(options)

    if options.empty? && @clip.all_likes_embedded?
      collection_class.new({"objects" => @clip.likes_data}, client)
    else
      collection_class.new(client.get(base_uri, options).body, client)
    end
  end

  def build
    Kippt::Like.new(client, clip)
  end

  def destroy_resource(resource)
    client.delete(base_uri).success?
  end
end
