require_relative "likes"

class Kippt::Like
  attr_reader :user, :errors

  def initialize(clip, client)
    @client = client
    @errors = []
    @clip   = clip
  end

  def id
    nil
  end

  def collection_resource_class
    Kippt::Likes
  end

  def writable_attributes_hash
    nil
  end

  def save
    @errors = []
    response = collection_resource.save_resource(self)
    if response[:error_message]
      errors << response[:error_message]
    end
    response[:success]
  end

  def destroy
    collection_resource.destroy_resource(self)
  end

  private

  def collection_resource
    @collection_resource ||= client.collection_resource_for(collection_resource_class, clip)
  end

  def client
    @client
  end

  def clip
    @clip
  end
end
