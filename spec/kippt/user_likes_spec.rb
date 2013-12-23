require "spec_helper"
require "kippt/user_likes"

describe Kippt::UserLikes do
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  subject { Kippt::User.new({:id => 10}, client).likes }
  let(:base_uri) { "users/10/clips/likes" }
  let(:singular_fixture) { "clip" }
  let(:collection_fixture) { "clips" }
  let(:collection_class) { Kippt::ClipCollection }
  let(:resource_class) { Kippt::Clip }

  it_behaves_like "read collection resource"
end
