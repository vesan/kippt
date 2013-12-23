require_relative "read_collection_resource"

# For fetching user's public likes.
class Kippt::UserLikes
  include Kippt::ReadCollectionResource

  attr_reader :user

  def initialize(client, user)
    @client = client
    @user   = user
  end

  def self.valid_filter_parameters
    [:limit, :offset, :include_data]
  end

  def object_class
    Kippt::Clip
  end

  def collection_class
    Kippt::ClipCollection
  end

  def base_uri
    "users/#{user.id}/clips/likes"
  end
end
