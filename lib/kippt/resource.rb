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
      @attribute_names = attribs.map {|attrib| attrib.to_sym }
      def_delegators :attributes, *@attribute_names
    end

    def writable_attributes(*attribs)
      @writable_attribute_names = attribs.map {|attrib| attrib.to_sym }
      @writable_attribute_names.freeze
      def_delegators :attributes, *(@writable_attribute_names.map {|attrib| attrib.to_s + "=" })
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
