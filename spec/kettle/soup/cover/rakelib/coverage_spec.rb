# frozen_string_literal: true

require "kettle/soup/cover/tasks"

# rubocop:disable RSpec/DescribeClass
# rubocop:disable RSpec/MultipleMemoizedHelpers
# Lightly modified from: https://thoughtbot.com/blog/test-rake-tasks-like-a-boss
RSpec.describe "rake coverage" do
  let(:rake) { Rake::Application.new }
  let(:task_name) { self.class.top_level_description.sub(/\Arake /, "") }
  let(:task_dir) { "lib/kettle/soup/cover/rakelib/" }
  let(:task_path) { File.join(task_dir, task_name.split(":").first) }
  let(:gem_root) { File.expand_path("../../../../../..", __FILE__) }
  let(:task_args) { [] }
  let(:rake_task) { rake[task_name] }

  before do
    Rake.application = rake
    Kettle::Soup::Cover.install_tasks
    load File.join(gem_root, "#{task_path}.rake")
    load File.join(gem_root, "spec/config/mocks/test_task.rake")
    rake_task.reenable # if this task was the one invoked to run the test suite it will have disappeared
    # test task is a dependency of the coverage task, so it must exist
  end

  it "has a gem root" do
    expect(gem_root).to end_with("kettle-soup-cover")
  end

  it "has name as coverage" do
    expect(task_name).to eq("coverage")
  end

  it "has task path" do
    expect(task_path).to eq("lib/kettle/soup/cover/rakelib/coverage")
  end

  context "when defined" do
    subject(:definition) { rake_task }

    it "has kettle-wash available for shipped constant reload support" do
      expect(Kettle::Wash).to respond_to(:reset_constants)
    end

    it "declares kettle-wash as a runtime dependency" do
      spec = Gem::Specification.load(File.join(gem_root, "kettle-soup-cover.gemspec"))
      dependency = spec.dependencies.find { |candidate| candidate.name == "kettle-wash" }

      expect(dependency).not_to be_nil
      expect(dependency.type).to eq(:runtime)
    end

    it "does not raise error" do
      block_is_expected.not_to raise_error
    end

    context "when invoked" do
      subject(:invocation) { invoked }

      let(:invoked) { rake_task.invoke(*task_args) }

      it "does not raise error" do
        block_is_expected.not_to raise_error
      end

      context "when OPEN_BIN empty" do
        let(:html_report) { "#{Kettle::Soup::Cover::COVERAGE_DIR}/index.html" }

        before do
          stub_const("Kettle::Soup::Cover::OPEN_BIN", "")
        end

        it "does not raise error" do
          block_is_expected.not_to raise_error
        end

        it "outputs where to find coverage report" do
          block_is_expected.to output("Kettle::Soup::Cover::OPEN_BIN not configured. Coverage report is at #{html_report}\n").to_stdout
        end
      end

      context "when OPEN_BIN set to unavailable executable" do
        let(:html_report) { "#{Kettle::Soup::Cover::COVERAGE_DIR}/index.html" }

        before do
          stub_const("Kettle::Soup::Cover::OPEN_BIN", "blah")
          allow(File).to receive(:exist?).and_call_original
          allow(File).to receive(:exist?).with(html_report).and_return(true)
        end

        it "does not raise error" do
          block_is_expected.not_to raise_error
        end

        it "outputs where to find coverage report" do
          block_is_expected.to output("Configured Kettle::Soup::Cover::OPEN_BIN (blah) not available. Coverage report is at #{html_report}\n").to_stdout
        end
      end

      context "when OPEN_BIN contains unavailable executable plus arguments" do
        let(:html_report) { "#{Kettle::Soup::Cover::COVERAGE_DIR}/index.html" }

        before do
          stub_const("Kettle::Soup::Cover::OPEN_BIN", "blah --bad")
          allow(File).to receive(:exist?).and_call_original
          allow(File).to receive(:exist?).with(html_report).and_return(true)
        end

        it "outputs where to find coverage report" do
          block_is_expected.to output(
            "Configured Kettle::Soup::Cover::OPEN_BIN (blah --bad) not available. Coverage report is at #{html_report}\n"
          ).to_stdout
        end
      end

      context "when OPEN_BIN succeeds" do
        let(:html_report) { "#{Kettle::Soup::Cover::COVERAGE_DIR}/index.html" }

        before do
          stub_const("Kettle::Soup::Cover::OPEN_BIN", "true --ignored")
          allow(File).to receive(:exist?).and_call_original
          allow(File).to receive(:exist?).with(html_report).and_return(true)
        end

        it "does not output a warning" do
          block_is_expected.not_to output.to_stdout
        end
      end

      context "when OPEN_BIN fails and the report is missing" do
        let(:html_report) { "#{Kettle::Soup::Cover::COVERAGE_DIR}/index.html" }

        before do
          stub_const("Kettle::Soup::Cover::OPEN_BIN", "false --ignored")
          allow(File).to receive(:exist?).and_call_original
          allow(File).to receive(:exist?).with(html_report).and_return(false)
        end

        it "outputs the missing coverage report message" do
          block_is_expected.to output(
            "No coverage report found at #{html_report}\n"
          ).to_stdout
        end
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
# rubocop:enable RSpec/DescribeClass
