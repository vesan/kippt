require_relative "user_collection"

class Kippt::Saves
  attr_reader :clip

  def initialize(client, clip)
    @client = client
    @clip   = clip
  end

  def collection_class
    Kippt::UserCollection
  end

  def fetch(options = {})
    collection_class.new({"objects" => @clip.saves_data}, client)
  end

  alias all fetch

  private

  def client
    @client
  end
end
