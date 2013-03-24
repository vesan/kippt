require "ostruct"
require "kippt/user"

class Kippt::List
  include Kippt::Resource

  attributes :app_url, :id, :rss_url, :updated, :title,
             :created, :slug, :resource_uri,
             :user => Kippt::User
  boolean_attributes :is_private

  writable_attributes :title

  def collection_resource_class
    Kippt::Lists
  end
end
