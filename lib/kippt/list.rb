require "ostruct"

class Kippt::List
  include Kippt::Resource

  attributes :app_url, :id, :rss_url, :updated, :title,
             :created, :slug, :resource_uri
  boolean_attributes :is_private

  writable_attributes :title
end
