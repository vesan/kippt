require "spec_helper"
require "kippt/clip_likes"

describe Kippt::ClipLikes do
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  subject { Kippt::Clip.new({:id => 10}, client).likes }
  let(:base_uri) { "clips/10/likes" }
  let(:singular_fixture) { "user" }
  let(:collection_fixture) { "users" }
  let(:collection_class) { Kippt::UserCollection }
  let(:resource_class) { Kippt::User }

  it_behaves_like "read collection resource"
end
