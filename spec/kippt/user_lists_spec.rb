require "spec_helper"
require "kippt/user_lists"

describe Kippt::UserLists do
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  subject { Kippt::User.new({:id => 10}, client).lists }
  let(:base_uri) { "users/#{10}/lists" }
  let(:singular_fixture) { "list" }
  let(:collection_class) { Kippt::ListCollection }
  let(:resource_class) { Kippt::List }

  it_behaves_like "collection resource"
end
