require "kippt/connection"
require "kippt/collection_resource"
require "kippt/list_collection"
require "kippt/list"

class Kippt::Lists
  include Kippt::CollectionResource

  def initialize(client)
    @client = client
  end

  def all(options = {})
    validate_collection_options(options)

    Kippt::ListCollection.new(@client.get("lists", options).body, self)
  end

  # def new
  # end

  def [](list_id)
    Kippt::List.new(@client.get("lists/#{list_id}").body)
  end

  def collection_from_url(url)
    Kippt::ListCollection.new(@client.get(url).body, self)
  end
end
