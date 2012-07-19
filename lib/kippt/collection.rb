module Kippt::Collection
  include Enumerable

  attr_reader :total_count, :limit, :offset

  def initialize(data, collection_resource = nil)
    meta         = data.fetch("meta")
    @limit       = meta.fetch("limit")
    @offset      = meta.fetch("offset")
    @next        = meta.fetch("next") { nil }
    @previous    = meta.fetch("previous") { nil }
    @total_count = meta.fetch("total_count")

    @collection_resource  = collection_resource

    @object_data = data.fetch("objects")
  end

  def objects
    @objects ||= @object_data.map {|data| object_class.new(data, @collection_resource) }
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

    @collection_resource.collection_from_url(@next)
  end

  def previous_page?
    @previous
  end
  alias_method :prev_page?, :previous_page?

  def previous_page
    raise Kippt::APIError.new("There is no previous page") if @previous.nil? || @previous == ""

    @collection_resource.collection_from_url(@previous)
  end
  alias_method :prev_page, :previous_page
end
