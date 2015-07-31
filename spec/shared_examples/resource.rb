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
    let(:collection_resource)  { double(:collection_resource) }

    it "sends delete request to the server" do
      client.stub(:collection_resource_for).and_return(collection_resource)
      collection_resource.should_receive(:destroy_resource).with(subject).and_return(true)
      subject.destroy.should be_truthy
    end
  end

  describe "#save" do
    context "with valid parameters" do
      let(:collection_resource)  { double(:collection_resource) }

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
        subject.save.should be_truthy
      end

      it "sets the updated attributes received from the server" do
        collection_resource.stub(:save_resource).and_return(
          {:success => true, :resource => {:id => 9999}})
        subject.save
        subject.id.should eq 9999
      end
    end

    context "with invalid parameters" do
      let(:collection_resource)  { double(:collection_resource) }

      before do
        client.stub(:collection_resource_for).and_return(collection_resource)
        collection_resource.stub(:save_resource).and_return({:success => false, :error_message => "No url."})
      end

      it "sets an error messages" do
        subject.save
        subject.errors.should eq ["No url."]
      end

      it "returns false" do
        subject.save.should be_falsey
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
