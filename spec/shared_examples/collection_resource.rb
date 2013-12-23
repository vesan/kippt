shared_examples_for "collection resource" do
  it_behaves_like "read collection resource"

  describe "#create" do
    let(:resource) { double :resource }

    it "builds and saves a resource" do
      resource.should_receive :save
      subject.should_receive(:build).with(:an => "attribute").and_return(resource)
      subject.create(:an => "attribute")
    end
  end

  # describe "#build" do
  #   it "initializes a new object of object class" do
  #     resource_class.should_receive(:new).with({test: "data"}, client)
  #     subject.build({test: "data"}).should be_a(resource_class)
  #   end
  # end
end
