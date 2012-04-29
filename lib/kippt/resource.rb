module Resource
  def self.included(base)
    base.instance_eval do
      extend Forwardable
      attr_reader :attributes, :errors
    end

    base.extend(ClassMethods)
  end

  module ClassMethods
    def attributes(*attribs)
      def_delegators :attributes, *attribs
    end

    def writable_attributes(*attribs)
      attribs.map! {|attrib| attrib.to_s + "=" }
      def_delegators :attributes, *attribs
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

  def save
    @errors = []
    response = @collection_resource.save_object(self)
    if response[:error_message]
      errors << response[:error_message]
    end
    response[:success]
  end
end
