require "kippt/connection"
require "kippt/collection_resource"
require "kippt/clips"
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
    Kippt::Clips.new(client, "#{base_uri}/favorites")
  end

  def likes
    Kippt::Clips.new(client, "#{base_uri}/likes")
  end
end
