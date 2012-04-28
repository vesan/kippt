require "kippt/connection"
require "kippt/collection_proxy"
require "kippt/clip_collection"
require "kippt/clip"

class Kippt::Clips
  include Kippt::Resource

  def initialize(client)
    @client = client
  end

  def all(options = {})
    validate_collection_options(options)

    Kippt::ClipCollection.new(@client.get("clips", options).body, self)
  end

  def build
    Kippt::Clip.new({}, self)
  end

  def [](clip_id)
    Kippt::Clip.new(@client.get("clips/#{clip_id}").body, self)
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

  def collection_from_url(url)
    Kippt::ClipCollection.new(@client.get(url).body, self)
  end

  def save_object(object)
    if object.id
      @client.put("clips/#{object.id}", writable_parameters_from(object))
    else
      @client.post("clips", writable_parameters_from(object))
    end
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
