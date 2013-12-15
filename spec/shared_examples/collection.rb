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
