require "spec_helper"

describe Kippt::ListCollection do
  let(:data) { MultiJson.load(fixture("lists.json").read) }
  subject { Kippt::ListCollection.new(data) }

  it_behaves_like "collection"
end
