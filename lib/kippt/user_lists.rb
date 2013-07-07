require "kippt/connection"
require "kippt/collection_resource"
require "kippt/list_collection"
require "kippt/list"

# Loads public lists for a user.
class Kippt::UserLists
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
    Kippt::List
  end

  def collection_class
    Kippt::ListCollection
  end

  def base_uri
    "users/#{user.id}/lists"
  end
end
