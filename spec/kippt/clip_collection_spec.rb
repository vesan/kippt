require "spec_helper"
require "kippt/clip_collection"

describe Kippt::ClipCollection do
  let(:data) { MultiJson.load(fixture("clips.json").read) }
  let(:data_with_multiple_pages) {
    MultiJson.load(fixture("clips_with_multiple_pages.json").read)
  }
  subject { Kippt::ClipCollection.new(data) }
  let(:subject_with_multiple_pages) { Kippt::ClipCollection.new(data_with_multiple_pages, collection_resource) }
  let(:collection_resource) { nil }

  it_behaves_like "collection"
end
