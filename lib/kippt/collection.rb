module Kippt::Collection
  include Enumerable

  attr_reader :total_count, :limit, :offset

  def initialize(data, client = nil)
    meta         = data.fetch("meta") { {} }
    @limit       = meta.fetch("limit") { nil }
    @offset      = meta.fetch("offset") { nil }
    @next        = meta.fetch("next") { nil }
    @previous    = meta.fetch("previous") { nil }
    @total_count = meta.fetch("total_count") { nil }

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

    collection_resource.collection_from_url(@next)
  end

  def previous_page?
    @previous
  end
  alias_method :prev_page?, :previous_page?

  def previous_page
    raise Kippt::APIError.new("There is no previous page") if @previous.nil? || @previous == ""

    collection_resource.collection_from_url(@previous)
  end
  alias_method :prev_page, :previous_page

  private

  def collection_resource
    @collection_resource ||= client.collection_resource_for(collection_resource_class)
  end

  def client
    @client
  end
end
