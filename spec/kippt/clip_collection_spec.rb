require "spec_helper"
require "kippt/clip_collection"

describe Kippt::ClipCollection do
  let(:data) { MultiJson.load(fixture("clips.json").read) }
  subject { Kippt::ClipCollection.new(data) }

  it_behaves_like "collection"
end
