require "spec_helper"
require "crack/json"
require "kippt/clip_collection"

describe Kippt::ClipCollection do
  let(:data) { Crack::JSON.parse(fixture("clips.json").read) }
  subject { Kippt::ClipCollection.new(data) }

  it_behaves_like "collection"
end