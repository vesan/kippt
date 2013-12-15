require "spec_helper"
require "kippt/followers"

describe Kippt::Followers do
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  subject { Kippt::User.new({:id => 10}, client).followers }

  it "is a collection resource" do
    subject.should be_a Kippt::CollectionResource
  end

  it "uses the correct base uri" do
    stub_get("/users/10/followers").
      to_return(:status => 200, :body => fixture("users.json"))
    subject.fetch
  end
end
