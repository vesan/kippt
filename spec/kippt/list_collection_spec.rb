require "spec_helper"

describe Kippt::ListCollection do
  let(:data) { MultiJson.load(fixture("lists.json").read) }
  let(:data_with_multiple_pages) {
    MultiJson.load(fixture("lists_with_multiple_pages.json").read)
  }
  subject { Kippt::ListCollection.new(data) }
  let(:subject_with_multiple_pages) { Kippt::ListCollection.new(data_with_multiple_pages, collection_resource) }
  let(:collection_resource) { nil }

  it_behaves_like "collection"
end
