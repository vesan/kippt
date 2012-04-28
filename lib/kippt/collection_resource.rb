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

  private

  def validate_collection_options(options)
    options.each do |key, _|
      unless [:limit, :offset].include?(key)
        raise ArgumentError.new("Unrecognized argument: #{key}")
      end
    end
  end
end
