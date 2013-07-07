require "kippt/connection"
require "kippt/collection_resource"
require "kippt/clip_collection"
require "kippt/clip"

class Kippt::UserClips
  include Kippt::CollectionResource

  attr_reader :user

  def self.valid_filter_parameters
    [:limit, :offset]
  end

  def initialize(client, user)
    @client = client
    @user   = user
  end

  def object_class
    Kippt::Clip
  end

  def collection_class
    Kippt::ClipCollection
  end

  def base_uri
    "users/#{user.id}/clips"
  end

  def favorites
    Kippt::ClipCollection.new(client.get("#{base_uri}/favorites").body, client)
  end

  def likes
    Kippt::ClipCollection.new(client.get("#{base_uri}/likes").body, client)
  end
end
