require "spec_helper"
require "kippt/lists"

describe Kippt::Lists do
  describe "#all" do
    subject { Kippt::Client.new(valid_user_credentials).lists }

    it "returns ListCollection" do
      stub_get("/lists").
        to_return(:status => 200, :body => fixture("lists.json"))
      lists = subject.all
      lists.is_a? Kippt::ListCollection
    end

    it "accepts limit and offset options" do
      stub_get("/lists?limit=10&offset=100").
        to_return(:status => 200, :body => fixture("lists.json"))
      lists = subject.all(:limit => 10, :offset => 100)
    end

    context "when passed unrecognized arguments" do
      it "raises error" do
        lambda {
          subject.all(:foobar => true)
        }.should raise_error(
          ArgumentError, "Unrecognized argument: foobar")
      end
    end
  end

  describe "#[]" do
    subject { Kippt::Client.new(valid_user_credentials).lists }

    it "fetches single list" do
      stub_get("/lists/10").
        to_return(:status => 200, :body => fixture("list.json"))
      subject[10].id.should eq 10
    end

    it "returns Kippt::List" do
      stub_get("/lists/10").
        to_return(:status => 200, :body => fixture("list.json"))
      subject[10].should be_a(Kippt::List)
    end
  end

  describe "#collection_from_url" do
    subject { Kippt::Client.new(valid_user_credentials).lists }

    it "returns a new ListCollection" do
      stub_get("/lists/?limit=20&offset=20").
        to_return(:status => 200, :body => fixture("lists.json"))
      list = subject.collection_from_url("/api/lists/?limit=20&offset=20")
      list.should be_a(Kippt::ListCollection)
    end
  end
end
