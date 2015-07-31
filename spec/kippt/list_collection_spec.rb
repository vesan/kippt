require "spec_helper"

describe Kippt::ListCollection do
  let(:data) { MultiJson.load(fixture("lists.json").read) }
  let(:data_with_multiple_pages) {
    MultiJson.load(fixture("lists_with_multiple_pages.json").read)
  }
  let(:client) { stub }
  subject { Kippt::ListCollection.new(data, client) }
  let(:subject_with_multiple_pages) { Kippt::ListCollection.new(data_with_multiple_pages, client) }
  let(:collection_resource_class) { Kippt::Lists }

  it_behaves_like "collection"
end
