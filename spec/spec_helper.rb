require "kippt"
require "rspec"
require "webmock/rspec"

def stub_get(url)
  stub_request(:get, kippt_url(url))
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

shared_examples_for "collection resource" do
  describe "#all" do
    it "returns collection class" do
      stub_get("/#{base_uri}").
        to_return(:status => 200, :body => fixture("#{base_uri}.json"))
      all_resources = subject.all
      all_resources.is_a? collection_class
    end

    it "accepts limit and offset options" do
      stub_get("/#{base_uri}?limit=10&offset=100").
        to_return(:status => 200, :body => fixture("#{base_uri}.json"))
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
  end

  describe "#collection_from_url" do
    it "returns a new collection" do
      stub_get("/#{base_uri}/?limit=20&offset=20").
        to_return(:status => 200, :body => fixture("#{base_uri}.json"))
      collection = subject.collection_from_url("/api/#{base_uri}/?limit=20&offset=20")
      collection.should be_a(collection_class)
    end
  end

  describe "#build" do
    it "returns new resource" do
      subject.build.should be_a(resource_class)
    end
  end
end

shared_examples_for "collection" do
  describe "#total_count" do
    it "returns total count of resources" do
      subject.total_count.should eq data["meta"]["total_count"]
    end
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
end

shared_examples_for "resource" do
  describe "attribute accessors" do
    it "delegates to attributes" do
      attributes.each do |attribute_name|
          subject.send(attribute_name).should eq data[attribute_name.to_s]
       end
    end
  end

  describe "#save" do
    context "with valid parameters" do
      it "sends POST request to server" do
        collection_resource.should_receive(:save_resource).with(subject).and_return({})
        subject.save
      end

      it "returns true" do
        collection_resource.stub(:save_resource).and_return(
          {success: true})
        subject.save.should be_true
      end
    end

    context "with invalid parameters" do
      before do
        collection_resource.stub(:save_resource).and_return({success: false, error_message: "No url."})
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
