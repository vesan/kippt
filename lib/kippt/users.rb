require_relative "user_collection"

class Kippt::Users
  include Kippt::CollectionResource
  VALID_SEARCH_PARAMETERS = [:q]

  def initialize(client)
    @client = client
  end

  def self.valid_filter_parameters
    [:limit, :offset]
  end

  def object_class
    Kippt::User
  end

  def collection_class
    Kippt::UserCollection
  end

  def base_uri
    "users"
  end

  def search(parameters)
    if parameters.is_a?(String)
      search({:q => parameters})
    else
      validate_search_parameters(parameters)

      Kippt::UserCollection.new(
        client.get("#{base_uri}/search", parameters).body,
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
