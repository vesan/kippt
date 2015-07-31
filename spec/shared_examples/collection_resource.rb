shared_examples_for "collection resource" do
  it_behaves_like "read collection resource"

  describe "#create" do
    let(:resource) { double :resource }

    it "builds and saves a resource" do
      expect(resource).to receive :save
      expect(subject).to receive(:build).with(:an => "attribute").and_return(resource)
      subject.create(:an => "attribute")
    end
  end
end
