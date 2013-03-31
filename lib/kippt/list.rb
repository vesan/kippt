require "kippt/user"

class Kippt::List
  include Kippt::Resource

  attributes :app_url, :id, :rss_url, :updated, :title,
             :created, :slug, :resource_uri, :description,
             :user => Kippt::User
  boolean_attributes :is_private

  writable_attributes :title, :description

  def collection_resource_class
    Kippt::Lists
  end

  def collaborators
    attributes.collaborators["data"].map {|collborator_data|
      Kippt::User.new(collborator_data, client)
    }
  end

  def follow
    response = client.post("#{resource_uri}relationship", :data => {:action => "follow"})
    raise Kippt::APIError.new("There was an error with the request: #{response.body["message"]}") unless response.success?
    response.success?
  end

  def unfollow
    response = client.post("#{resource_uri}relationship", :data => {:action => "unfollow"})
    raise Kippt::APIError.new("There was an error with the request: #{response.body["message"]}") unless response.success?
    response.success?
  end
end
