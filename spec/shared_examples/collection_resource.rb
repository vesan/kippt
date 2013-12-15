shared_examples_for "collection resource" do
  def collection_fixture
    base_uri.split("/").last
  end

  describe "#fetch" do
    it "returns collection class" do
      stub_get("/#{base_uri}").
        to_return(:status => 200, :body => fixture("#{collection_fixture}.json"))
      all_resources = subject.fetch
      all_resources.is_a? collection_class
    end

    it "accepts limit and offset options" do
      stub_get("/#{base_uri}?limit=10&offset=100").
        to_return(:status => 200, :body => fixture("#{collection_fixture}.json"))
      resources = subject.fetch(:limit => 10, :offset => 100)
    end

    context "when passed unrecognized arguments" do
      it "raises error" do
        lambda {
          subject.fetch(:foobar => true)
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

  describe "#create" do
    let(:resource) { double :resource }

    it "builds and saves a resource" do
      resource.should_receive :save
      subject.should_receive(:build).with(:an => "attribute").and_return(resource)
      subject.create(:an => "attribute")
    end
  end
end
