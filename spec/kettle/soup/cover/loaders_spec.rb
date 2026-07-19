# frozen_string_literal: true

RSpec.describe Kettle::Soup::Cover::Loaders do
  include_context "with stubbed env"

  before do
    @original_formatters = SimpleCov.formatters
    reset_soup_cover_constants do
      stub_env("CI" => ci)
      stub_env("K_SOUP_COV_FORMATTERS" => formatters)
    end
  end

  after do
    SimpleCov.formatters = @original_formatters
  end

  let(:ci) { "false" }
  let(:formatters) { "html,tty" }

  describe "#load_formatters" do
    subject(:load_formatters) { described_class.load_formatters }

    it "succeeds" do
      block_is_expected.not_to raise_error
    end

    context "when CI=true" do
      let(:ci) { "true" }

      it "succeeds" do
        block_is_expected.not_to raise_error
      end
    end

    context "when FORMATTERS=lcov" do
      let(:formatters) { "lcov" }

      it "succeeds" do
        block_is_expected.not_to raise_error
      end
    end

    context "when FORMATTERS is empty" do
      let(:formatters) { "" }

      it "succeeds" do
        block_is_expected.not_to raise_error
      end
    end
  end

  describe "#load_filters" do
    subject(:load_filters) { described_class.load_filters }

    it "succeeds" do
      block_is_expected.not_to raise_error
    end
  end

  describe "#install_tasks" do
    subject(:install_tasks) { described_class.install_tasks }

    it "succeeds" do
      block_is_expected.not_to raise_error
    end
  end
end
