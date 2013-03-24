require "ostruct"
require "kippt/resource"
require "kippt/user"

class Kippt::Clip
  include Kippt::Resource

  attributes :url_domain, :updated, :is_starred, :title,
             :url, :notes, :created, :list, :id, :resource_uri,
             :user => Kippt::User

  writable_attributes :is_starred, :title, :url, :notes, :list
end
