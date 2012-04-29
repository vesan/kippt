require "spec_helper"
require "kippt/lists"

describe Kippt::Lists do
  subject { Kippt::Client.new(valid_user_credentials).lists }
  let(:base_uri) { "lists" }
  let(:singular_fixture) { "list" }
  let(:collection_class) { Kippt::ListCollection }
  let(:resource_class) { Kippt::List }

  it_behaves_like "collection resource"
end
