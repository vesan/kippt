require "ostruct"

class Kippt::List
  include Resource

  attributes :id, :rss_url, :updated, :title,
             :created, :slug, :resource_uri

  writable_attributes :title
end
