unless ENV["CI"] == "true"
  require "simplecov"
  SimpleCov.start
end

require "kippt"
require "rspec"
require "webmock/rspec"

def stub_get(url)
  stub_request(:get, kippt_url(url))
end

def stub_post(url)
  stub_request(:post, kippt_url(url))
end

def stub_put(url)
  stub_request(:put, kippt_url(url))
end

def stub_delete(url)
  stub_request(:delete, kippt_url(url))
end

def kippt_url(url)
  "https://kippt.com/api#{url}"
end

def valid_user_credentials
  {:username => "bob", :token => "bobstoken"}
end

def fixture(file)
  fixture_path = File.expand_path("../fixtures", __FILE__)
  File.new(fixture_path + '/' + file)
end

def json_fixture(file)
  MultiJson.load(fixture(file).read)
end

shared_examples_for "collection resource" do
  def collection_fixture
    base_uri.split("/").last
  end

  describe "#all" do
    it "returns collection class" do
      stub_get("/#{base_uri}").
        to_return(:status => 200, :body => fixture("#{collection_fixture}.json"))
      all_resources = subject.all
      all_resources.is_a? collection_class
    end

    it "accepts limit and offset options" do
      stub_get("/#{base_uri}?limit=10&offset=100").
        to_return(:status => 200, :body => fixture("#{collection_fixture}.json"))
      resources = subject.all(:limit => 10, :offset => 100)
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
    it "fetches single resource" do
      stub_get("/#{base_uri}/10").
        to_return(:status => 200, :body => fixture("#{singular_fixture}.json"))
      subject[10].id.should eq 10
    end

    it "returns resource" do
      stub_get("/#{base_uri}/10").
        to_return(:status => 200, :body => fixture("#{singular_fixture}.json"))
      subject[10].should be_a(resource_class)
    end

    context "when resource is not found" do
      it "raises exception" do
        stub_get("/#{base_uri}/10").
          to_return(:status => 404, :body => {"message" => "Resource not found."})
        lambda {
          subject[10]
          subject.all(:foobar => true)
        }.should raise_error(
          Kippt::APIError, "Resource could not be loaded: Resource not found.")
      end
    end
  end

  describe "#find" do
    it "exists" do
      subject.respond_to?(:find).should be_true
    end
  end

  describe "#collection_from_url" do
    it "returns a new collection" do
      stub_get("/#{base_uri}/?limit=20&offset=20").
        to_return(:status => 200, :body => fixture("#{collection_fixture}.json"))
      collection = subject.collection_from_url("/api/#{base_uri}/?limit=20&offset=20")
      collection.should be_a(collection_class)
    end

    context "when passed URL is blank" do
      it "raises ArgumentError" do
        lambda {
          subject.collection_from_url("")
        }.should raise_error(ArgumentError, "The parameter URL can't be blank")
        lambda {
          subject.collection_from_url(nil)
        }.should raise_error(ArgumentError, "The parameter URL can't be blank")
      end
    end
  end

  describe "#build" do
    it "returns new resource" do
      subject.build.should be_a(resource_class)
    end

    it "accepts parameters" do
      subject.object_class.should_receive(:new).with({:an => "attribute"}, client)
      subject.build(:an => "attribute")
    end
  end
end

shared_examples_for "collection" do
  it "is Enumberable" do
    subject.should be_a(Enumerable)
  end

  describe "#offset" do
    it "returns offset of the results" do
      subject.offset.should eq 0
    end
  end

  describe "#limit" do
    it "returns limit of the results" do
      subject.limit.should eq 20
    end
  end

  describe "#objects" do
    it "returns the objects generated from the data" do
      subject.objects.each do |object|
        object.should be_a(subject.object_class)
      end
    end
  end

  describe "#[]" do
    it "returns a object by index" do
      subject[0].id.should eq data["objects"][0]["id"]
    end
  end

  describe "#each" do
    it "loops through the objects" do
      ids = []
      subject.each {|object| ids << object.id }
      ids.should eq data["objects"].map { |node| node["id"] }
    end
  end

  describe "#next_page?" do
    context "there is a next page" do
      it "returns url of the page" do
        subject_with_multiple_pages.next_page?.should eq data_with_multiple_pages["meta"]["next"]
      end
    end

    context "there is no next page" do
      it "returns nil" do
        subject.next_page?.should eq nil
      end
    end
  end

  describe "#next_page" do
    context "if there is a next page" do
      let(:collection_resource) { stub }

      it "gets the next page of results from the collection resource" do
        client.stub(:collection_resource_for).and_return(collection_resource)

        results = stub
        collection_resource.should_receive(:collection_from_url).
          with(data_with_multiple_pages["meta"]["next"]).
          and_return(results)

        subject_with_multiple_pages.next_page.should eq results
      end
    end

    context "if there is no next page" do
      it "raises an error" do
        lambda {
          subject.next_page
        }.should raise_error(Kippt::APIError, "There is no next page")
      end
    end
  end

  describe "#previous_page?" do
    context "there is a previous page" do
      it "returns url of the page" do
        subject_with_multiple_pages.previous_page?.should eq data_with_multiple_pages["meta"]["previous"]
      end
    end

    context "there is no previous page" do
      it "returns nil" do
        subject.previous_page?.should be_nil
      end
    end
  end

  describe "#previous_page" do
    context "if there is a previous page" do
      let(:collection_resource) { stub }

      it "gets the previous page of results from the collection resource" do
        client.stub(:collection_resource_for).and_return(collection_resource)

        results = stub
        collection_resource.should_receive(:collection_from_url).
          with(data_with_multiple_pages["meta"]["previous"]).
          and_return(results)

        subject_with_multiple_pages.previous_page.should eq results
      end
    end

    context "if there is no previous page" do
      it "raises an error" do
        lambda {
          subject.previous_page
        }.should raise_error(Kippt::APIError, "There is no previous page")
      end
    end
  end
end

shared_examples_for "resource" do
  describe "attribute accessors" do
    it "delegates to attributes" do
      attributes.each do |attribute_name|
        subject.send(attribute_name).should eq data[attribute_name.to_s]
      end
    end
  end

  describe "mapped attribute accessors" do
    it "delegates to attributes and wraps with to a object" do
      mapped_attributes.each do |attribute_name, attribute_class|
        subject.send(attribute_name).class.to_s.should eq attribute_class
      end
    end
  end

  describe "#destroy" do
    let(:collection_resource)  { stub }

    it "sends delete request to the server" do
      client.stub(:collection_resource_for).and_return(collection_resource)
      collection_resource.should_receive(:destroy_resource).with(subject).and_return(true)
      subject.destroy.should be_true
    end
  end

  describe "#save" do
    context "with valid parameters" do
      let(:collection_resource)  { stub }

      before do
        client.stub(:collection_resource_for).and_return(collection_resource)
      end

      it "sends POST request to server" do
        collection_resource.should_receive(:save_resource).with(subject).and_return({})
        subject.save
      end

      it "returns true" do
        collection_resource.stub(:save_resource).and_return(
          {:success => true})
        subject.save.should be_true
      end

      it "sets the updated attributes received from the server" do
        collection_resource.stub(:save_resource).and_return(
          {:success => true, :resource => {:id => 9999}})
        subject.save
        subject.id.should eq 9999
      end
    end

    context "with invalid parameters" do
      let(:collection_resource)  { stub }

      before do
        client.stub(:collection_resource_for).and_return(collection_resource)
        collection_resource.stub(:save_resource).and_return({:success => false, :error_message => "No url."})
      end

      it "sets an error messages" do
        subject.save
        subject.errors.should eq ["No url."]
      end

      it "returns false" do
        subject.save.should be_false
      end

      it "clears previous errors" do
        subject.save
        subject.errors.should eq ["No url."]
        subject.save
        subject.errors.should eq ["No url."]
      end
    end
  end
end
