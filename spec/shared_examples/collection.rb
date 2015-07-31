shared_examples_for "collection" do
  it "is Enumberable" do
    expect(subject).to be_a(Enumerable)
  end

  describe "#offset" do
    it "returns offset of the results" do
      expect(subject.offset).to eq 0
    end
  end

  describe "#limit" do
    it "returns limit of the results" do
      expect(subject.limit).to eq 20
    end
  end

  describe "#objects" do
    it "returns the objects generated from the data" do
      subject.objects.each do |object|
        expect(object).to be_a(subject.object_class)
      end
    end
  end

  describe "#[]" do
    it "returns a object by index" do
      expect(subject[0].id).to eq data["objects"][0]["id"]
    end
  end

  describe "#each" do
    it "loops through the objects" do
      ids = []
      subject.each {|object| ids << object.id }
      expect(ids).to eq data["objects"].map { |node| node["id"] }
    end
  end

  describe "#next_page?" do
    context "there is a next page" do
      it "returns url of the page" do
        expect(subject_with_multiple_pages.next_page?).to eq data_with_multiple_pages["meta"]["next"]
      end
    end

    context "there is no next page" do
      it "returns nil" do
        expect(subject.next_page?).to eq nil
      end
    end
  end

  describe "#next_page" do
    context "if there is a next page" do
      let(:collection_resource) { double(:collection_resource) }

      it "gets the next page of results from the collection resource" do
        expect(client).to receive(:collection_resource_for).with(collection_resource_class, data_with_multiple_pages["meta"]["next"]).and_return(collection_resource)

        results = double :results
        expect(collection_resource).to receive(:fetch).
          and_return(results)

        expect(subject_with_multiple_pages.next_page).to eq results
      end
    end

    context "if there is no next page" do
      it "raises an error" do
        expect {
          subject.next_page
        }.to raise_error(Kippt::APIError, "There is no next page")
      end
    end
  end

  describe "#previous_page?" do
    context "there is a previous page" do
      it "returns url of the page" do
        expect(subject_with_multiple_pages.previous_page?).to eq data_with_multiple_pages["meta"]["previous"]
      end
    end

    context "there is no previous page" do
      it "returns nil" do
        expect(subject.previous_page?).to be_nil
      end
    end
  end

  describe "#previous_page" do
    context "if there is a previous page" do
      let(:collection_resource) { double(:collection_resource) }

      it "gets the previous page of results from the collection resource" do
        expect(client).to receive(:collection_resource_for)
          .with(collection_resource_class, data_with_multiple_pages["meta"]["previous"])
          .and_return(collection_resource)

        results = double :results
        expect(collection_resource).to receive(:fetch).
          and_return(results)

        expect(subject_with_multiple_pages.previous_page).to eq results
      end
    end

    context "if there is no previous page" do
      it "raises an error" do
        expect {
          subject.previous_page
        }.to raise_error(Kippt::APIError, "There is no previous page")
      end
    end
  end
end
