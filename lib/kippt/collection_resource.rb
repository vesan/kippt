module Kippt::CollectionResource
  def all(options = {})
    validate_collection_options(options)

    collection_class.new(@client.get(base_uri, options).body, self)
  end

  def build
    object_class.new({}, self)
  end

  def [](resource_id)
    object_class.new(@client.get("#{base_uri}/#{resource_id}").body)
  end

  def collection_from_url(url)
    collection_class.new(@client.get(url).body, self)
  end

  def save_resource(object)
    if object.id
      response = @client.put("#{base_uri}/#{object.id}", :data => writable_parameters_from(object))
    else
      response = @client.post("#{base_uri}", :data => writable_parameters_from(object))
    end

    save_response = {:success => response.success?}
    if response.body["message"]
      save_response[:error_message] = response.body["message"]
    end
    save_response
  end

  def destroy_resource(resource)
    if resource.id
      @client.delete("#{base_uri}/#{resource.id}").success?
    end
  end

  private

  def validate_collection_options(options)
    options.each do |key, _|
      unless [:limit, :offset].include?(key)
        raise ArgumentError.new("Unrecognized argument: #{key}")
      end
    end
  end

  def writable_parameters_from(resource)
    resource.writable_attributes_hash
  end
end
