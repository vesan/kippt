require_relative "read_collection_resource"

module Kippt
  module CollectionResource
    include Kippt::ReadCollectionResource

    class SaveResponse
      attr_reader :response

      def initialize(response)
        @response = response
      end

      def [](key)
        return @save_response[key] if @save_response

        @save_response = {success: response.success?, resource: response.body}
        if response.body["message"]
          @save_response[:error_message] = response.body["message"]
        end

        @save_response[key]
      end

      def success?
        self[:success]
      end
    end

    def build(attributes = {})
      object_class.new(attributes, client)
    end

    def create(attributes = {})
      build(attributes).save
    end

    def save_resource(object)
      if object.id
        response = client.put("#{base_uri}/#{object.id}", :data => writable_parameters_from(object))
      else
        response = client.post("#{base_uri}", :data => writable_parameters_from(object))
      end

      SaveResponse.new(response)
    end

    def destroy_resource(resource)
      if resource.id
        client.delete("#{base_uri}/#{resource.id}").success?
      end
    end

    private

    def writable_parameters_from(resource)
      resource.writable_attributes_hash
    end
  end
end
