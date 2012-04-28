require "kippt/connection"
require "kippt/collection_resource"
require "kippt/clip_collection"
require "kippt/clip"

class Kippt::Clips
  include Kippt::CollectionResource

  def initialize(client)
    @client = client
  end

  def object_class
    Kippt::Clip
  end

  def collection_class
    Kippt::ClipCollection
  end

  def base_uri
    "clips"
  end

  def search(parameters)
    # TODO: Validate parameters
    if parameters.is_a?(String)
      Kippt::ClipCollection.new(
        @client.get("search/clips", {:q => parameters}).body,
        self)
    else
      Kippt::ClipCollection.new(
        @client.get("search/clips", parameters).body,
        self)
    end
  end

  def save_object(object)
    if object.id
      response = @client.put("clips/#{object.id}", writable_parameters_from(object))
    else
      response = @client.post("clips", writable_parameters_from(object))
    end

    save_response = {success: response.success?}
    if response.body["message"]
      save_response[:error_message] = response.body["message"]
    end
    save_response
  end

  private

  def writable_parameters_from(clip)
    [:url, :title, :list, :notes, :is_starred].
      inject({}) do |parameters, attribute_name|
        unless clip.send(attribute_name).nil?
          parameters[attribute_name] = clip.send(attribute_name)
        end
        parameters
    end
  end
end
