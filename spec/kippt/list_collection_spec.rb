require "spec_helper"
require "crack/json"

describe Kippt::ListCollection do
  let(:data) { Crack::JSON.parse(fixture("lists.json").read) }
  subject { Kippt::ListCollection.new(data) }

  it_behaves_like "collection"
end
