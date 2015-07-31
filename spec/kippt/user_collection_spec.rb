require "spec_helper"
require "kippt/user_collection"

describe Kippt::UserCollection do
  let(:data) { MultiJson.load(fixture("users.json").read) }
  let(:data_with_multiple_pages) {
    MultiJson.load(fixture("users_with_multiple_pages.json").read)
  }
  let(:client) { stub }
  subject { Kippt::UserCollection.new(data, client) }
  let(:subject_with_multiple_pages) { Kippt::UserCollection.new(data_with_multiple_pages, client) }
  let(:collection_resource_class) { Kippt::Users }

  it_behaves_like "collection"
end
