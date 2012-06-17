require "kippt/connection"
require "kippt/collection_resource"
require "kippt/clip_collection"
require "kippt/clip"

class Kippt::Clips
  include Kippt::CollectionResource
  VALID_SEARCH_PARAMETERS = [:q, :list, :is_starred]

  def initialize(client)
    @client = client
  end

  def object_class
    Kippt::Clip
  end

  def collection_class
    Kippt::ClipCollection
  end

  def base_uri
    "clips"
  end

  def search(parameters)
    # TODO: Validate parameters
    if parameters.is_a?(String)
      Kippt::ClipCollection.new(
        @client.get("search/clips", {:q => parameters}).body,
        self)
    else
      validate_search_parameters(parameters)

      Kippt::ClipCollection.new(
        @client.get("search/clips", parameters).body,
        self)
    end
  end

  private

  def validate_search_parameters(parameters)
    parameters.each do |key, value|
      raise ArgumentError.new("'#{key}' is not a valid search parameter") unless VALID_SEARCH_PARAMETERS.include?(key)
    end
  end
end
