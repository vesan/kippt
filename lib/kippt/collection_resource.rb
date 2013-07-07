module Kippt::CollectionResource
  # For certain objects you can get extra data by giving option `include_data`.
  # For example with clips you can add `include_data: "list,via"`.
  def all(options = {})
    validate_collection_options(options)

    collection_class.new(client.get(base_uri, options).body, client)
  end

  def build(attributes = {})
    object_class.new(attributes, client)
  end

  def create(attributes = {})
    build(attributes).save
  end

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

  def collection_from_url(url)
    raise ArgumentError.new("The parameter URL can't be blank") if url.nil? || url == ""

    collection_class.new(client.get(url).body, client)
  end

  def save_resource(object)
    if object.id
      response = client.put("#{base_uri}/#{object.id}", :data => writable_parameters_from(object))
    else
      response = client.post("#{base_uri}", :data => writable_parameters_from(object))
    end

    save_response = {:success => response.success?}
    save_response[:resource] = response.body
    if response.body["message"]
      save_response[:error_message] = response.body["message"]
    end

    save_response
  end

  def destroy_resource(resource)
    if resource.id
      client.delete("#{base_uri}/#{resource.id}").success?
    end
  end

  private

  def validate_collection_options(options)
    options.each do |key, _|
      unless self.class.valid_filter_parameters.include?(key)
        raise ArgumentError.new("Unrecognized argument: #{key}")
      end
    end
  end

  def writable_parameters_from(resource)
    resource.writable_attributes_hash
  end

  def client
    @client
  end
end
