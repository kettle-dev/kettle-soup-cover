# frozen_string_literal: true

RSpec.describe "CONTRIBUTING template sync" do
  it "keeps the help section and DCO section unique" do
    content = File.read(File.expand_path("../../CONTRIBUTING.md", __dir__))

    expect(content.scan(/^## Developer Certificate of Origin$/).size).to eq(1)
    expect(content.scan(/^## Help out!$/).size).to eq(1)
    expect(content.scan(/^Follow these instructions:$/).size).to eq(1)
    expect(content.scan(/^1\. Join the community:/).size).to eq(1)
  end
end
