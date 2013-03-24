module Kippt::Resource
  def self.included(base)
    base.instance_eval do
      extend Forwardable
      attr_reader :attributes, :errors

      def_delegators "self.class", :writable_attribute_names, :attribute_names, :embedded_attribute_names
    end

    base.extend(ClassMethods)
  end

  module ClassMethods
    attr_reader :writable_attribute_names, :attribute_names

    def embedded_attribute_names
      @embedded_attribute_names || []
    end

    def attributes(*attribs)
      @attribute_names ||= []
      hashes, other = attribs.partition {|attrib| attrib.is_a? Hash }

      attribute_names = convert_to_symbols(other)
      def_delegators :attributes, *attribute_names
      @attribute_names += attribute_names

      mappings = hashes.reduce({}, :update)
      mappings.each do |attrib, object_class|
        define_method(attrib) do
          object_class.new(attributes.send(attrib))
        end
      end
      @attribute_names += convert_to_symbols(mappings.keys)
    end

    def boolean_attributes(*attribs)
      @attribute_names ||= []
      attribute_names = convert_to_symbols(attribs)
      def_delegators :attributes, *attribute_names
      @attribute_names += attribute_names

      attribs.each do |attribute_name|
        if result = attribute_name.to_s.match(/\Ais\_(.*)/)
          define_method "#{result[1]}?" do
            send(attribute_name) if respond_to?(attribute_name)
          end
        end
      end
    end

    def writable_attributes(*attribs)
      @writable_attribute_names = convert_to_symbols(attribs)
      @writable_attribute_names.freeze
      def_delegators :attributes, *(@writable_attribute_names.map {|attrib| attrib.to_s + "=" }).dup
    end

    def embedded_attributes(*attribs)
      mappings = attribs.reduce({}, :update)
      @embedded_attribute_names = convert_to_symbols(mappings.keys)
      @embedded_attribute_names.freeze

      mappings.each do |attrib, attribute_class|
        define_method(attrib) do
          value = attributes.send(attrib)
          if value.is_a? String
            client.resource_from_url(attribute_class, value)
          else
            attribute_class.new(value)
          end
        end
      end
    end

    private

    def convert_to_symbols(list)
      list.map {|item| item.to_sym }
    end
  end

  def initialize(attributes = {}, client = nil)
    @attributes = OpenStruct.new(attributes)
    @errors     = []
    @client     = client
  end

  def destroy
    collection_resource.destroy_resource(self)
  end

  def writable_attributes_hash
    writable_attribute_names.inject({}) do |parameters, attribute_name|
      value = self.send(attribute_name)
      if embedded_attribute_names.include?(attribute_name) && !value.is_a?(String)
        value = value.resource_uri
      end
      unless value.nil?
        parameters[attribute_name] = value
      end
      parameters
    end
  end

  def save
    @errors = []
    response = collection_resource.save_resource(self)
    if response[:error_message]
      errors << response[:error_message]
    else
      if response[:resource]
        updated_attributes = response[:resource].select do |key, _|
          attribute_names.include?(key.to_sym)
        end
        @attributes = OpenStruct.new(updated_attributes)
      end
    end
    response[:success]
  end

  private

  def collection_resource
    @collection_resource ||= client.collection_resource_for(collection_resource_class)
  end

  def client
    @client
  end
end
