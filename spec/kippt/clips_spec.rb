require "spec_helper"
require "kippt/clips"

describe Kippt::Clips do
  describe "#all" do
    subject { Kippt::Client.new(valid_user_credentials).clips }

    it "returns ClipCollection" do
      stub_get("/clips").
        to_return(:status => 200, :body => fixture("clips.json"))
      clips = subject.all
      clips.is_a? Kippt::ClipCollection
    end

    it "accepts limit and offset options" do
      stub_get("/clips?limit=10&offset=100").
        to_return(:status => 200, :body => fixture("clips.json"))
      clips = subject.all(:limit => 10, :offset => 100)
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
    subject { Kippt::Client.new(valid_user_credentials).clips }

    it "fetches single list" do
      stub_get("/clips/10").
        to_return(:status => 200, :body => fixture("list.json"))
      subject[10].id.should eq 10
    end

    it "returns Kippt::Clip" do
      stub_get("/clips/10").
        to_return(:status => 200, :body => fixture("list.json"))
      subject[10].should be_a(Kippt::Clip)
    end
  end

  describe "#build" do
    subject { Kippt::Client.new(valid_user_credentials).clips }

    it "returns Kippt::Clip" do
      subject.build.should be_a(Kippt::Clip)
    end
  end

  describe "#search" do
    subject { Kippt::Client.new(valid_user_credentials).clips }

    describe "parameters" do
      it "accepts String" do
        stub_get("/search/clips?q=bunny").
          to_return(:status => 200, :body => fixture("clips.json"))
        subject.search("bunny")
      end

      it "accepts Hash" do
        stub_get("/search/clips?q=bunny&list=4&is_starred=true").
          to_return(:status => 200, :body => fixture("clips.json"))
        subject.search(:q => "bunny", :list => 4, :is_starred => true)
      end
    end

    it "returns ClipCollection" do
      stub_get("/search/clips?q=bunny").
        to_return(:status => 200, :body => fixture("clips.json"))
      clips = subject.search("bunny")
      clips.is_a? Kippt::ClipCollection
    end
  end

  describe "#save_object" do
    subject { Kippt::Client.new(valid_user_credentials).clips }

    context "when object doesn't have an id" do
      it "POSTs new resource to the API" do
       stub_request(:post, "https://kippt.com/api/clips").
         with(:body => "{\"url\":\"http://kiskolabs.com\"}").
         to_return(:status => 200, :body => "", :headers => {})

        clip = Kippt::Clip.new(:url => "http://kiskolabs.com")
        subject.save_object(clip)
      end
    end
    
    context "when object has an id" do
      it "PUTs new version of the resource to the API" do
       stub_request(:put, "https://kippt.com/api/clips/22").
         with(:body => "{\"url\":\"http://kiskolabs.com\"}").
         to_return(:status => 200, :body => "", :headers => {})

        clip = Kippt::Clip.new(:id => 22, :url => "http://kiskolabs.com")
        subject.save_object(clip)
      end 
    end
  end
end