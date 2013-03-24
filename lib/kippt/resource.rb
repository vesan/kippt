module Kippt::Resource
  def self.included(base)
    base.instance_eval do
      extend Forwardable
      attr_reader :attributes, :errors

      def_delegators "self.class", :writable_attribute_names, :attribute_names
    end

    base.extend(ClassMethods)
  end

  module ClassMethods
    attr_reader :writable_attribute_names, :attribute_names

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

    private

    def convert_to_symbols(list)
      list.map {|item| item.to_sym }
    end
  end

  def initialize(attributes = {}, collection_resource = nil)
    @attributes = OpenStruct.new(attributes)
    @errors     = []
    @collection_resource   = collection_resource
  end

  def destroy
    @collection_resource.destroy_resource(self)
  end

  def writable_attributes_hash
    writable_attribute_names.inject({}) do |parameters, attribute_name|
      value = self.send(attribute_name)
      unless value.nil?
        parameters[attribute_name] = value
      end
      parameters
    end
  end

  def save
    @errors = []
    response = @collection_resource.save_resource(self)
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
end
