module Kippt::Collection
  include Enumerable

  attr_reader :limit, :offset

  def initialize(data, client = nil)
    meta         = data.fetch("meta") { {} }
    @limit       = meta.fetch("limit") { nil }
    @offset      = meta.fetch("offset") { nil }
    @next        = meta.fetch("next") { nil }
    @previous    = meta.fetch("previous") { nil }

    @client  = client

    @object_data = data.fetch("objects")
  end

  extend Forwardable
  def_delegators :objects, :size, :length

  def objects
    @objects ||= @object_data.map {|data| object_class.new(data, client) }
  end

  def [](index)
    objects[index]
  end

  def each(&block)
    objects.each(&block)
  end

  def next_page?
    @next
  end

  def next_page
    raise Kippt::APIError.new("There is no next page") if @next.nil? || @next == ""

    collection_resource_from_url(@next).fetch
  end

  def previous_page?
    @previous
  end
  alias_method :prev_page?, :previous_page?

  def previous_page
    raise Kippt::APIError.new("There is no previous page") if @previous.nil? || @previous == ""

    collection_resource_from_url(@previous).fetch
  end
  alias_method :prev_page, :previous_page

  private

  def collection_resource_from_url(url)
    client.collection_resource_for(collection_resource_class, url)
  end

  def client
    @client
  end
end
