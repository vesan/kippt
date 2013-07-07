require "kippt/user_collection"
require "kippt/user"

class Kippt::Saves
  attr_reader :clip

  def initialize(client, clip)
    @client = client
    @clip   = clip
  end

  def collection_class
    Kippt::UserCollection
  end

  def all(options = {})
    collection_class.new({"objects" => @clip.saves_data}, client)
  end

  private

  def client
    @client
  end
end
