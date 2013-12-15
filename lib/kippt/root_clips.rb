require_relative "clips"

# The root "/clips" resource that exposes features like feed, favorites and
# search.
class Kippt::RootClips < Kippt::Clips
  VALID_SEARCH_PARAMETERS = [:q, :list, :is_starred]

  def initialize(client)
    super(client, "clips")
  end

  def feed
    Kippt::Clips.new(client, "clips/feed")
  end

  def favorites
    Kippt::Clips.new(client, "clips/favorites")
  end

  def search(parameters)
    if parameters.is_a?(String)
      search({:q => parameters})
    else
      validate_search_parameters(parameters)

      Kippt::ClipCollection.new(
        client.get("search/clips", parameters).body,
        client)
    end
  end

  private

  def validate_search_parameters(parameters)
    parameters.each do |key, value|
      raise ArgumentError.new("'#{key}' is not a valid search parameter") unless VALID_SEARCH_PARAMETERS.include?(key)
    end
  end
end
