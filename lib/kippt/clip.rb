require "ostruct"
require "kippt/resource"

class Kippt::Clip
  include Kippt::Resource

  attributes :url_domain, :updated, :is_starred, :title,
             :url, :notes, :created, :list, :id, :resource_uri

  writable_attributes :is_starred, :title, :url, :notes, :list
end
