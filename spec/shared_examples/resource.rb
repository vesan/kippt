shared_examples_for "resource" do
  describe "attribute accessors" do
    it "delegates to attributes" do
      attributes.each do |attribute_name|
        expect(subject.send(attribute_name)).to eq data[attribute_name.to_s]
      end
    end
  end

  describe "mapped attribute accessors" do
    it "delegates to attributes and wraps with to a object" do
      mapped_attributes.each do |attribute_name, attribute_class|
        expect(subject.send(attribute_name).class.to_s).to eq attribute_class
      end
    end
  end

  describe "#destroy" do
    let(:collection_resource)  { double(:collection_resource) }

    it "sends delete request to the server" do
      allow(client).to receive(:collection_resource_for).and_return(collection_resource)
      expect(collection_resource).to receive(:destroy_resource).with(subject).and_return(true)
      expect(subject.destroy).to be_truthy
    end
  end

  describe "#save" do
    context "with valid parameters" do
      let(:collection_resource)  { double(:collection_resource) }

      before do
        allow(client).to receive(:collection_resource_for).and_return(collection_resource)
      end

      it "sends POST request to server" do
        expect(collection_resource).to receive(:save_resource).with(subject).and_return({})
        subject.save
      end

      it "returns true" do
        allow(collection_resource).to receive(:save_resource).and_return(
          {:success => true})
        expect(subject.save).to be_truthy
      end

      it "sets the updated attributes received from the server" do
        allow(collection_resource).to receive(:save_resource).and_return(
          {:success => true, :resource => {:id => 9999}})
        subject.save
        expect(subject.id).to eq 9999
      end
    end

    context "with invalid parameters" do
      let(:collection_resource)  { double(:collection_resource) }

      before do
        allow(client).to receive(:collection_resource_for).and_return(collection_resource)
        allow(collection_resource).to receive(:save_resource).and_return({:success => false, :error_message => "No url."})
      end

      it "sets an error messages" do
        subject.save
        expect(subject.errors).to eq ["No url."]
      end

      it "returns false" do
        expect(subject.save).to be_falsey
      end

      it "clears previous errors" do
        subject.save
        expect(subject.errors).to eq ["No url."]
        subject.save
        expect(subject.errors).to eq ["No url."]
      end
    end
  end
end
