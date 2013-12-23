require "spec_helper"
require "kippt/lists"

describe Kippt::Lists do
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  subject { client.lists }
  let(:base_uri) { "lists" }
  let(:singular_fixture) { "list" }
  let(:collection_fixture) { "lists" }
  let(:collection_class) { Kippt::ListCollection }
  let(:resource_class) { Kippt::List }

  it_behaves_like "collection resource"
end
