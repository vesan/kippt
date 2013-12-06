require "kippt/connection"
require "kippt/collection_resource"
require "kippt/clip_collection"
require "kippt/clip"

# Generic clip proxy. Used to wrap endpoints that return clips as JSON.
class Kippt::Clips
  include Kippt::CollectionResource
  VALID_SEARCH_PARAMETERS = [:q, :list, :is_starred]

  attr_reader :base_uri

  def initialize(client, base_uri)
    @client = client
    @base_uri = base_uri
  end

  def self.valid_filter_parameters
    [:limit, :offset, :is_read_later, :is_starred]
  end

  def object_class
    Kippt::Clip
  end

  def collection_class
    Kippt::ClipCollection
  end
end
