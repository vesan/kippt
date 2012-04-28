module Kippt::Collection
  attr_reader :total_count, :limit, :offset

  def initialize(data, collection_proxy = nil)
    meta         = data.fetch("meta")
    @limit       = meta.fetch("limit")
    @offset      = meta.fetch("offset")
    @next        = meta.fetch("next") { nil }
    @prev        = meta.fetch("prev") { nil }
    @total_count = meta.fetch("total_count")

    @collection_proxy  = collection_proxy

    @object_data = data.fetch("objects")
  end

  def objects
    @objects ||= @object_data.map {|data| object_class.new(data) }
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
    # TODO: Raise error if there is no page
    @collection_proxy.collection_from_url(@next)
  end

  def prev_page?
    @prev
  end

  def prev_page
    # TODO: Raise error if there is no page
    @collection_proxy.collection_from_url(@prev)
  end
end
