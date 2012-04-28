require "spec_helper"
require "kippt/client"

describe Kippt::Client do
  describe "#initialize" do
    context "when there is no username" do
      it "raises error"
    end

    context "when there is no password or token" do
      it "raises error"
    end
  end

  describe "#lists" do
  end
end
