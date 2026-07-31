# frozen_string_literal: true

require "anonymous_loader"
require "kettle/soup/cover/version_gem"
RSpec.describe Kettle::Soup::Cover::Version do
  it_behaves_like "a Version module", described_class

  it "executes the version file for coverage without redefining constants" do
    paths = [
      File.expand_path("../../../../lib/kettle/soup/cover/version.rb", __dir__),
      File.expand_path("../../../../lib/kettle/soup/cover/version_gem.rb", __dir__)
    ].select { |path| File.file?(path) }
    anonymous_namespace = AnonymousLoader.load(files: paths)

    expect(anonymous_namespace::Kettle::Soup::Cover::Version::VERSION).to eq(described_class::VERSION)
  end
end
