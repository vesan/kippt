require "spec_helper"
require "kippt/user_collection"

describe Kippt::UserCollection do
  let(:data) { MultiJson.load(fixture("users.json").read) }
  let(:data_with_multiple_pages) {
    MultiJson.load(fixture("users_with_multiple_pages.json").read)
  }
  subject { Kippt::UserCollection.new(data, collection_resource) }
  let(:subject_with_multiple_pages) { Kippt::UserCollection.new(data_with_multiple_pages, collection_resource) }
  let(:collection_resource) { nil }

  it_behaves_like "collection"
end
