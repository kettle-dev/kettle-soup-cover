# frozen_string_literal: true

require "kettle/soup/cover/tasks"

# rubocop:disable RSpec/DescribeClass
# rubocop:disable RSpec/MultipleDescribes
RSpec.describe "rake turbo_tests:cleanup" do
  let(:rake) { Rake::Application.new }
  let(:gem_root) { File.expand_path("../../../../../..", __FILE__) }

  before do
    Rake.application = rake
    Kettle::Soup::Cover.install_tasks
    load File.join(gem_root, "lib/kettle/soup/cover/rakelib/turbo_tests.rake")
  end

  it "collates turbo_tests2 coverage on cleanup" do
    allow(Kettle::Soup::Cover).to receive(:collate_turbo_tests_coverage!).and_return(:collated)

    rake["turbo_tests:cleanup"].invoke

    expect(Kettle::Soup::Cover).to have_received(:collate_turbo_tests_coverage!)
  end
end

RSpec.describe "rake turbo_tests2:cleanup" do
  let(:rake) { Rake::Application.new }
  let(:gem_root) { File.expand_path("../../../../../..", __FILE__) }

  before do
    Rake.application = rake
    Kettle::Soup::Cover.install_tasks
    load File.join(gem_root, "lib/kettle/soup/cover/rakelib/turbo_tests.rake")
  end

  it "collates turbo_tests2 coverage on cleanup" do
    allow(Kettle::Soup::Cover).to receive(:collate_turbo_tests_coverage!).and_return(:collated)

    rake["turbo_tests2:cleanup"].invoke

    expect(Kettle::Soup::Cover).to have_received(:collate_turbo_tests_coverage!)
  end
end

RSpec.describe "rake turbo_tests:setup" do
  let(:rake) { Rake::Application.new }
  let(:gem_root) { File.expand_path("../../../../../..", __FILE__) }

  before do
    Rake.application = rake
    Kettle::Soup::Cover.install_tasks
    load File.join(gem_root, "lib/kettle/soup/cover/rakelib/turbo_tests.rake")
  end

  it "clears shared coverage output when coverage is enabled" do
    allow(Kettle::Soup::Cover).to receive(:turbo_tests_coverage?).and_return(true)
    allow(Kettle::Soup::Cover).to receive(:clear_coverage_dir!)

    rake["turbo_tests:setup"].invoke

    expect(Kettle::Soup::Cover).to have_received(:clear_coverage_dir!)
  end

  it "does not clear shared coverage output when coverage is disabled" do
    allow(Kettle::Soup::Cover).to receive(:turbo_tests_coverage?).and_return(false)
    allow(Kettle::Soup::Cover).to receive(:clear_coverage_dir!)

    rake["turbo_tests:setup"].invoke

    expect(Kettle::Soup::Cover).not_to have_received(:clear_coverage_dir!)
  end
end

RSpec.describe "rake turbo_tests2:setup" do
  let(:rake) { Rake::Application.new }
  let(:gem_root) { File.expand_path("../../../../../..", __FILE__) }

  before do
    Rake.application = rake
    Kettle::Soup::Cover.install_tasks
    load File.join(gem_root, "lib/kettle/soup/cover/rakelib/turbo_tests.rake")
  end

  it "clears shared coverage output when coverage is enabled" do
    allow(Kettle::Soup::Cover).to receive(:turbo_tests_coverage?).and_return(true)
    allow(Kettle::Soup::Cover).to receive(:clear_coverage_dir!)

    rake["turbo_tests2:setup"].invoke

    expect(Kettle::Soup::Cover).to have_received(:clear_coverage_dir!)
  end

  it "does not clear shared coverage output when coverage is disabled" do
    allow(Kettle::Soup::Cover).to receive(:turbo_tests_coverage?).and_return(false)
    allow(Kettle::Soup::Cover).to receive(:clear_coverage_dir!)

    rake["turbo_tests2:setup"].invoke

    expect(Kettle::Soup::Cover).not_to have_received(:clear_coverage_dir!)
  end
end
# rubocop:enable RSpec/MultipleDescribes
# rubocop:enable RSpec/DescribeClass
