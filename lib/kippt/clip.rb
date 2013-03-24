require "ostruct"
require "kippt/resource"
require "kippt/user"
require "kippt/list"

class Kippt::Clip
  include Kippt::Resource

  attributes :url_domain, :updated, :is_starred, :title,
             :url, :notes, :created, :id, :resource_uri,
             :type, :favicon_url, :app_url, :media,
             :user => Kippt::User

  writable_attributes :is_favorite, :title, :url, :notes, :list
  alias_method :is_starred, :is_favorite
  alias_method :is_starred=, :is_favorite=

  embedded_attributes :list => Kippt::List

  def collection_resource_class
    Kippt::Clips
  end

  def list_uri
    if attributes.list.is_a? String
      attributes.list
    else
      list.resource_uri
    end
  end
end
