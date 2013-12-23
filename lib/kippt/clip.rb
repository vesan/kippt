require_relative "comments"
require_relative "clip_likes"
require_relative "like"
require_relative "saves"
require_relative "list"

class Kippt::Clip
  include Kippt::Resource

  attributes :url_domain, :is_starred, :title,
             :url, :notes, :id, :resource_uri,
             :type, :favicon_url, :app_url, :media,
             :updated => Time, :created => Time,
             :user => Kippt::User

  writable_attributes :is_favorite, :title, :url, :notes, :list

  boolean_attributes :is_favorite

  alias :is_starred :is_favorite
  alias :is_starred= :is_favorite=
  alias :starred? :favorite?

  embedded_attributes :list => "Kippt::List", :via => "Kippt::Clip"

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

  def comments
    Kippt::Comments.new(client, self)
  end

  def all_comments_embedded?
    comments_count == comments_data.size
  end

  def comments_count
    attributes.comments["count"]
  end

  def comments_data
    attributes.comments["data"]
  end

  def likes
    Kippt::ClipLikes.new(client, self)
  end

  def all_likes_embedded?
    likes_count == likes_data.size
  end

  def likes_count
    attributes.likes["count"]
  end

  def likes_data
    attributes.likes["data"]
  end

  def saves
    Kippt::Saves.new(client, self)
  end

  def saves_count
    attributes.saves["count"]
  end

  def saves_data
    attributes.saves["data"]
  end

  def like
    Kippt::Like.new(self, client).save
  end

  def unlike
    Kippt::Like.new(self, client).destroy
  end
end
