module Kippt::ReadCollectionResource
  include Kippt::Helpers

  # For certain objects you can get extra data by giving option `include_data`.
  # For example with clips you can add `include_data: "list,via"`.
  def fetch(options = {})
    validate_collection_options(options)

    collection_class.new(client.get(base_uri, options).body, client)
  end

  alias all fetch

  # For certain objects you can get extra data by giving option `include_data`.
  # For example with clips you can add `include_data: "list,via"`.
  def [](resource_id, options = {})
    response = client.get("#{base_uri}/#{resource_id}", options)
    if response.success?
      object_class.new(response.body, client)
    else
      raise Kippt::APIError.new("Resource could not be loaded: #{response.body["message"]}")
    end
  end

  alias find []

  private

  def validate_collection_options(options)
    symbolize_keys! options
    assert_valid_keys options, self.class.valid_filter_parameters
  end

  def client
    @client
  end
end
