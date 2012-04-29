require "spec_helper"
require "crack/json"
require "kippt/clip_collection"

describe Kippt::ClipCollection do
  let(:data) { Crack::JSON.parse(fixture("clip.json").read) }
  subject { Kippt::Clip.new(data) }

  it_behaves_like "resource"
end
