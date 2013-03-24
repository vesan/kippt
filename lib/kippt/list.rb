require "ostruct"
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
end
