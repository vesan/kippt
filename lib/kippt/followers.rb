require "kippt/collection_resource"
require "kippt/user_collection"
require "kippt/user"

class Kippt::Followers
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
    Kippt::User
  end

  def collection_class
    Kippt::UserCollection
  end

  def base_uri
    "users/#{user.id}/followers"
  end
end
