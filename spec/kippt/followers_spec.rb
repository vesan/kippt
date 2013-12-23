require "spec_helper"
require "kippt/followers"

describe Kippt::Followers do
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  subject { Kippt::User.new({:id => 10}, client).followers }
  let(:base_uri) { "users/10/followers" }
  let(:singular_fixture) { "user" }
  let(:collection_fixture) { "users" }
  let(:resource_class) { Kippt::User }
  let(:collection_class) { Kippt::UserCollection }

  it_behaves_like "read collection resource"
end
