# frozen_string_literal: true

require "open3"
require "stringio"

RSpec.describe Kettle::Soup::Cover do
  include_context "with stubbed env"

  describe "SimpleCov config" do
    it "leaves turbo_tests2 worker merge finalization to parent collation" do
      env = {
        "K_SOUP_COV_FORMATTERS" => "unknown",
        "K_SOUP_COV_TURBO_TESTS" => "true",
        "TEST_ENV_NUMBER" => "2"
      }
      script = <<~RUBY
        require "simplecov"
        require "kettle-soup-cover"
        require "kettle/soup/cover/config"
        puts SimpleCov.finalize_merge?
      RUBY

      stdout, stderr, status = Open3.capture3(env, RbConfig.ruby, "-Ilib", "-e", script)

      expect(status).to be_success, stderr
      expect(stdout).to eq("false\n")
    end
  end

  describe "::clean_resultset!" do
    subject(:clean_resultset!) { described_class.clean_resultset! }

    let(:tmp_dir) { Dir.mktmpdir }
    let(:resultset_path) { File.join(tmp_dir, ".resultset.json") }

    before do
      allow(SimpleCov::ResultMerger).to receive(:resultset_path).and_return(resultset_path)
    end

    after { FileUtils.remove_entry(tmp_dir) }

    context "when the resultset file exists" do
      before { File.write(resultset_path, "{}") }

      it "deletes the file" do
        expect { clean_resultset! }.to change { File.exist?(resultset_path) }.from(true).to(false)
      end
    end

    context "when the resultset file does not exist" do
      it "does not raise an error" do
        block_is_expected.to not_raise_error
      end
    end
  end

  describe "::clear_coverage_dir!" do
    subject(:clear_coverage_dir!) { described_class.clear_coverage_dir!(coverage_dir, project_root: project_root) }

    let(:project_root) { Dir.mktmpdir }
    let(:coverage_dir) { "coverage" }
    let(:resolved_coverage_dir) { File.join(project_root, coverage_dir) }

    before do
      FileUtils.mkdir_p(resolved_coverage_dir)
      File.write(File.join(resolved_coverage_dir, "coverage.json"), "{}")
    end

    after { FileUtils.remove_entry(project_root) }

    it "removes the configured coverage dir" do
      expect { clear_coverage_dir! }.to change { File.exist?(resolved_coverage_dir) }.from(true).to(false)
    end
  end

  describe "::clear_turbo_tests_coverage_dir!" do
    subject(:clear_turbo_tests_coverage_dir!) do
      described_class.clear_turbo_tests_coverage_dir!(coverage_dir, project_root: project_root)
    end

    let(:project_root) { Dir.mktmpdir }
    let(:coverage_dir) { "coverage" }
    let(:turbo_dir) { File.join(project_root, coverage_dir, "turbo_tests") }

    before do
      FileUtils.mkdir_p(File.join(turbo_dir, "1"))
      File.write(File.join(turbo_dir, "1", ".resultset.json"), "{}")
    end

    after { FileUtils.remove_entry(project_root) }

    it "removes only the turbo_tests coverage directory" do
      expect { clear_turbo_tests_coverage_dir! }.to change { File.exist?(turbo_dir) }.from(true).to(false)
      expect(File.exist?(File.join(project_root, coverage_dir))).to be(true)
    end
  end

  describe "::turbo_tests_resultset_paths" do
    subject(:turbo_tests_resultset_paths) do
      described_class.turbo_tests_resultset_paths(coverage_dir, project_root: project_root)
    end

    let(:project_root) { Dir.mktmpdir }
    let(:coverage_dir) { "coverage" }
    let(:resultset_path) { File.join(project_root, coverage_dir, "turbo_tests", "1", ".resultset.json") }

    before do
      FileUtils.mkdir_p(File.dirname(resultset_path))
      File.write(resultset_path, "{}")
    end

    after { FileUtils.remove_entry(project_root) }

    it "finds worker resultsets" do
      expect(turbo_tests_resultset_paths).to eq([resultset_path])
    end
  end

  describe "::turbo_tests_json_paths" do
    subject(:turbo_tests_json_paths) do
      described_class.turbo_tests_json_paths(coverage_dir, project_root: project_root)
    end

    let(:project_root) { Dir.mktmpdir }
    let(:coverage_dir) { "coverage" }
    let(:json_path) { File.join(project_root, coverage_dir, "turbo_tests", "1", "coverage.json") }

    before do
      FileUtils.mkdir_p(File.dirname(json_path))
      File.write(json_path, "{}")
    end

    after { FileUtils.remove_entry(project_root) }

    it "finds worker JSON reports" do
      expect(turbo_tests_json_paths).to eq([json_path])
    end
  end

  describe "::turbo_tests_coverage?" do
    it "is true when coverage and turbo_tests2 support are enabled" do
      stub_const("Kettle::Soup::Cover::Constants::DO_COV", true)
      stub_const("Kettle::Soup::Cover::Constants::TURBO_TESTS", true)

      expect(described_class.turbo_tests_coverage?).to be(true)
    end

    it "is false when coverage is disabled" do
      stub_const("Kettle::Soup::Cover::Constants::DO_COV", false)
      stub_const("Kettle::Soup::Cover::Constants::TURBO_TESTS", true)

      expect(described_class.turbo_tests_coverage?).to be(false)
    end

    it "is false when turbo_tests2 support is disabled" do
      stub_const("Kettle::Soup::Cover::Constants::DO_COV", true)
      stub_const("Kettle::Soup::Cover::Constants::TURBO_TESTS", false)

      expect(described_class.turbo_tests_coverage?).to be(false)
    end
  end

  describe "::configure_formatters!" do
    before do
      allow(Kettle::Soup::Cover::Loaders).to receive(:load_formatters)
      allow(SimpleCov).to receive(:at_exit)
      allow(SimpleCov).to receive(:formatter)
    end

    context "when running in a turbo_tests2 worker" do
      before do
        stub_const("Kettle::Soup::Cover::Constants::TURBO_TESTS_WORKER", true)
        stub_const("Kettle::Soup::Cover::Constants::MULTI_FORMATTERS", true)
      end

      it "uses the configured formatter stack in the worker coverage directory" do
        described_class.configure_formatters!

        expect(Kettle::Soup::Cover::Loaders).to have_received(:load_formatters)
        expect(SimpleCov).not_to have_received(:at_exit)
        expect(SimpleCov).not_to have_received(:formatter)
      end
    end

    context "when the parent process uses multiple formatters" do
      before do
        stub_const("Kettle::Soup::Cover::Constants::TURBO_TESTS_WORKER", false)
        stub_const("Kettle::Soup::Cover::Constants::MULTI_FORMATTERS", true)
      end

      it "loads the configured formatter stack" do
        described_class.configure_formatters!

        expect(Kettle::Soup::Cover::Loaders).to have_received(:load_formatters)
        expect(SimpleCov).not_to have_received(:at_exit)
        expect(SimpleCov).not_to have_received(:formatter)
      end
    end

    context "when the parent process uses the default single formatter" do
      before do
        stub_const("Kettle::Soup::Cover::Constants::TURBO_TESTS_WORKER", false)
        stub_const("Kettle::Soup::Cover::Constants::MULTI_FORMATTERS", false)
      end

      it "uses the HTML formatter" do
        described_class.configure_formatters!

        expect(SimpleCov).to have_received(:formatter).with(SimpleCov::Formatter::HTMLFormatter)
        expect(SimpleCov).not_to have_received(:at_exit)
        expect(Kettle::Soup::Cover::Loaders).not_to have_received(:load_formatters)
      end
    end
  end

  describe "::collate_turbo_tests_coverage!" do
    subject(:collate_turbo_tests_coverage!) do
      described_class.collate_turbo_tests_coverage!(coverage_dir, project_root: project_root)
    end

    let(:project_root) { Dir.mktmpdir }
    let(:coverage_dir) { "coverage" }
    let(:resultset_path) { File.join(project_root, coverage_dir, "turbo_tests", "1", ".resultset.json") }

    before do
      allow(described_class).to receive_messages(
        turbo_tests_coverage?: turbo_tests_coverage,
        turbo_tests_resultset_paths: resultsets
      )
    end

    after { FileUtils.remove_entry(project_root) }

    context "when turbo_tests2 coverage is disabled" do
      let(:turbo_tests_coverage) { false }
      let(:resultsets) { [resultset_path] }

      it { is_expected.to eq(:disabled) }
    end

    context "when no worker resultsets exist" do
      let(:turbo_tests_coverage) { true }
      let(:resultsets) { [] }

      it { is_expected.to eq(:empty) }
    end

    context "when worker resultsets exist" do
      let(:turbo_tests_coverage) { true }
      let(:resultsets) { [resultset_path] }

      before do
        stub_const("Kettle::Soup::Cover::Constants::COMMAND_NAME", "Specs")
        stub_const("Kettle::Soup::Cover::Constants::FILTER_DIRS", ["tmp"])
        stub_const("Kettle::Soup::Cover::Constants::MIN_COVERAGE_BRANCH", 76)
        stub_const("Kettle::Soup::Cover::Constants::MIN_COVERAGE_LINE", 92)
        stub_const("Kettle::Soup::Cover::Constants::MIN_COVERAGE_HARD", true)
        stub_const("Kettle::Soup::Cover::Constants::MULTI_FORMATTERS", true)
        stub_const("Kettle::Soup::Cover::Constants::TURBO_TESTS_WORKER", false)
        allow(Kettle::Soup::Cover::Loaders).to receive(:load_formatters)
        allow(SimpleCov).to receive(:collate) do |_resultsets, &block|
          SimpleCov.instance_eval(&block)
        end
        allow(SimpleCov).to receive(:command_name)
        allow(SimpleCov).to receive(:enable_coverage)
        allow(SimpleCov).to receive(:primary_coverage)
        allow(SimpleCov).to receive(:skip)
        allow(SimpleCov).to receive(:coverage_dir)
        allow(SimpleCov).to receive(:minimum_coverage)
      end

      it "collates with hard minimums and configured formatters" do
        allow(described_class).to receive(:publish_turbo_tests_json_coverage!).and_return(:published)

        expect(collate_turbo_tests_coverage!).to eq(:collated)
        expect(SimpleCov).to have_received(:collate).with(resultsets)
        expect(SimpleCov).to have_received(:command_name).with("Specs (turbo_tests2)")
        expect(SimpleCov).to have_received(:enable_coverage).with(:branch)
        expect(SimpleCov).to have_received(:primary_coverage).with(:branch)
        expect(SimpleCov).to have_received(:skip).with(["tmp"])
        expect(SimpleCov).to have_received(:coverage_dir).with(File.join(project_root, coverage_dir))
        expect(SimpleCov).to have_received(:minimum_coverage).with(branch: 76, line: 92)
        expect(Kettle::Soup::Cover::Loaders).to have_received(:load_formatters)
        expect(described_class).to have_received(:publish_turbo_tests_json_coverage!).with(coverage_dir, project_root: project_root)
      end

      context "when multi formatters are disabled" do
        before do
          stub_const("Kettle::Soup::Cover::Constants::MULTI_FORMATTERS", false)
          allow(SimpleCov).to receive(:formatter)
        end

        it "uses the default HTML formatter" do
          expect(collate_turbo_tests_coverage!).to eq(:collated)

          expect(SimpleCov).to have_received(:formatter).with(SimpleCov::Formatter::HTMLFormatter)
          expect(Kettle::Soup::Cover::Loaders).not_to have_received(:load_formatters)
        end
      end

      context "when hard minimums are disabled" do
        before do
          stub_const("Kettle::Soup::Cover::Constants::MIN_COVERAGE_HARD", false)
        end

        it "collates without enforcing minimums" do
          expect(collate_turbo_tests_coverage!).to eq(:collated)

          expect(SimpleCov).not_to have_received(:minimum_coverage)
        end
      end
    end
  end

  describe "::publish_turbo_tests_json_coverage!" do
    subject(:publish_turbo_tests_json_coverage!) do
      described_class.publish_turbo_tests_json_coverage!(coverage_dir, project_root: project_root)
    end

    let(:project_root) { Dir.mktmpdir }
    let(:coverage_dir) { "coverage" }
    let(:first_worker) { File.join(project_root, coverage_dir, "turbo_tests", "1") }
    let(:second_worker) { File.join(project_root, coverage_dir, "turbo_tests", "2") }
    let(:output_path) { File.join(project_root, coverage_dir, "coverage.json") }

    after { FileUtils.remove_entry(project_root) }

    context "when no worker JSON reports exist" do
      it { is_expected.to eq(:empty) }
    end

    context "when worker JSON reports exist" do
      before do
        FileUtils.mkdir_p(first_worker)
        FileUtils.mkdir_p(second_worker)
        File.write(
          File.join(first_worker, "coverage.json"),
          JSON.pretty_generate(
            "meta" => {"simplecov_version" => "0.22.0"},
            "coverage" => {
              "lib/a.rb" => {
                "lines" => [1, 0, nil],
                "branches" => [
                  {"type" => "then", "coverage" => 0},
                  {"type" => "else", "coverage" => "ignored"}
                ]
              }
            }
          )
        )
        File.write(
          File.join(second_worker, "coverage.json"),
          JSON.pretty_generate(
            "coverage" => {
              "lib/a.rb" => {
                "lines" => [0, 2, nil],
                "branches" => [
                  {"type" => "then", "coverage" => 3},
                  {"type" => "else", "coverage" => 1}
                ]
              }
            }
          )
        )
      end

      it "writes merged worker coverage to the canonical JSON path" do
        expect(publish_turbo_tests_json_coverage!).to eq(:published)

        merged = JSON.parse(File.read(output_path))
        expect(merged.fetch("meta")).to include("simplecov_version" => "0.22.0")
        expect(merged.dig("coverage", "lib/a.rb", "lines")).to eq([1, 2, nil])
        expect(merged.dig("coverage", "lib/a.rb", "branches")).to contain_exactly(
          include("type" => "then", "coverage" => 3),
          include("type" => "else", "coverage" => 1)
        )
      end
    end
  end

  describe "::merge_branch_entry" do
    let(:left_entry) { {"type" => "then", "coverage" => 1} }
    let(:right_entry) { {"type" => "then", "coverage" => 2} }

    it "keeps right-only branch entries" do
      expect(described_class.merge_branch_entry(nil, right_entry)).to eq(right_entry)
    end

    it "keeps left-only branch entries" do
      expect(described_class.merge_branch_entry(left_entry, nil)).to eq(left_entry)
    end

    it "keeps non-hash left entries unchanged" do
      expect(described_class.merge_branch_entry("ignored", right_entry)).to eq("ignored")
    end
  end

  describe "::merge_coverage_value" do
    it "sums covered counts from multiple workers" do
      expect(described_class.merge_coverage_value(1, 2)).to eq(3)
    end

    it "keeps existing covered counts when the incoming value is not covered" do
      expect(described_class.merge_coverage_value(1, nil)).to eq(1)
    end

    it "keeps incoming covered counts when the existing value is not covered" do
      expect(described_class.merge_coverage_value(nil, 2)).to eq(2)
    end

    it "keeps non-count existing values before falling back to the incoming value" do
      expect(described_class.merge_coverage_value("ignored", nil)).to eq("ignored")
      expect(described_class.merge_coverage_value(nil, "ignored")).to eq("ignored")
    end
  end

  describe "::coverage_task_env" do
    subject(:coverage_task_env) { described_class.coverage_task_env(coverage_dir, project_root: project_root) }

    let(:project_root) { Dir.mktmpdir }
    let(:coverage_dir) { "custom-coverage" }

    after { FileUtils.remove_entry(project_root) }

    it "forces a fresh json-only coverage run in the configured directory" do
      expect(coverage_task_env).to eq(
        {
          "K_SOUP_COV_PREFIX" => "K_SOUP_COV_",
          "K_SOUP_COV_DIR" => File.join(project_root, coverage_dir),
          "K_SOUP_COV_DO" => "true",
          "K_SOUP_COV_FORMATTERS" => "json",
          "K_SOUP_COV_MIN_HARD" => "false",
          "K_SOUP_COV_MULTI_FORMATTERS" => "true",
          "K_SOUP_COV_OPEN_BIN" => ""
        }
      )
    end
  end

  describe "::refresh_coverage_data!" do
    subject(:refresh_coverage_data!) do
      described_class.refresh_coverage_data!(
        coverage_dir,
        project_root: project_root,
        out: out,
        err: err
      )
    end

    let(:project_root) { Dir.mktmpdir }
    let(:coverage_dir) { "coverage" }
    let(:resolved_coverage_dir) { File.join(project_root, coverage_dir) }
    let(:out) { StringIO.new }
    let(:err) { StringIO.new }
    let(:coverage_task) { File.join(project_root, "bin", "rake") }

    before do
      FileUtils.mkdir_p(resolved_coverage_dir)
      File.write(File.join(resolved_coverage_dir, "coverage.json"), "{}")
    end

    after { FileUtils.remove_entry(project_root) }

    it "clears the coverage dir and runs the coverage task with json-only output" do
      allow(described_class).to receive(:system).and_return(true)

      refresh_coverage_data!

      expect(described_class).to have_received(:system).with(
        {
          "K_SOUP_COV_PREFIX" => "K_SOUP_COV_",
          "K_SOUP_COV_DIR" => resolved_coverage_dir,
          "K_SOUP_COV_DO" => "true",
          "K_SOUP_COV_FORMATTERS" => "json",
          "K_SOUP_COV_MIN_HARD" => "false",
          "K_SOUP_COV_MULTI_FORMATTERS" => "true",
          "K_SOUP_COV_OPEN_BIN" => ""
        },
        coverage_task,
        "coverage",
        chdir: project_root,
        out: out,
        err: err
      )

      expect(File.exist?(resolved_coverage_dir)).to be(false)
    end

    it "raises when the coverage task fails" do
      allow(described_class).to receive(:system).and_return(false)

      expect { refresh_coverage_data! }.to raise_error(
        described_class::Error,
        "Coverage refresh failed: #{coverage_task} coverage"
      )
    end
  end

  describe "::display_path" do
    it "returns nil unchanged" do
      expect(described_class.display_path(nil)).to be_nil
    end

    it "leaves other paths unchanged" do
      expect(described_class.display_path("/home/pboling/src/my/demo/coverage/index.html"))
        .to eq("/home/pboling/src/my/demo/coverage/index.html")
    end

    it "normalizes /var/home to /home for emitted report paths" do
      expect(described_class.display_path("/var/home/pboling/src/my/demo/coverage/index.html"))
        .to eq("/home/pboling/src/my/demo/coverage/index.html")
    end
  end

  describe "::load_filters" do
    subject(:load_filters) { described_class.load_filters }

    it "does not raise error" do
      block_is_expected.to not_raise_error
    end
  end

  describe "::load_formatters" do
    subject(:load_formatters) { described_class.load_formatters }

    it "does not raise error" do
      block_is_expected.to not_raise_error
    end
  end

  context "when CI=true" do
    before do
      reset_soup_cover_constants do
        stub_env("CI" => "true")
        stub_env("K_SOUP_COV_FORMATTERS" => nil)
        stub_env("MAX_ROWS" => nil)
      end
    end

    it "sets CI" do
      expect(described_class::CI).to eq("true")
    end

    it "sets IS_CI" do
      expect(described_class::IS_CI).to be(true)
    end

    it "sets FORMATTERS" do
      formatters = described_class::FORMATTERS.map { |x| x[:type] }
      expect(formatters).to eq(%i[html xml rcov lcov json tty])
    end

    it "sets MULTI_FORMATTERS_DEFAULT" do
      expect(described_class::MULTI_FORMATTERS_DEFAULT).to eq("true")
    end
  end

  context "when CI=false" do
    before do
      reset_soup_cover_constants do
        stub_env("CI" => "false")
        stub_env("K_SOUP_COV_FORMATTERS" => nil)
        stub_env("MAX_ROWS" => nil)
      end
    end

    it "sets CI" do
      expect(described_class::CI).to eq("false")
    end

    it "sets IS_CI" do
      expect(described_class::IS_CI).to be(false)
    end

    it "sets FORMATTERS" do
      formatters = described_class::FORMATTERS.map { |x| x[:type] }
      expect(formatters).to eq(%i[html tty])
    end

    context "when MAX_ROWS is '0'" do
      before do
        reset_soup_cover_constants do
          stub_env(
            "CI" => "false",
            "K_SOUP_COV_FORMATTERS" => nil,
            "MAX_ROWS" => "0"
          )
        end
      end

      it "omits the tty formatter when MAX_ROWS=0" do
        formatters = described_class::FORMATTERS.map { |x| x[:type] }
        expect(formatters).to eq(%i[html])
      end
    end

    context "when K_SOUP_COV_MULTI_FORMATTERS not empty" do
      it "sets MULTI_FORMATTERS_DEFAULT" do
        expect(described_class::MULTI_FORMATTERS_DEFAULT).to eq("true")
      end
    end

    context "when K_SOUP_COV_MULTI_FORMATTERS empty" do
      before do
        reset_soup_cover_constants do
          stub_env(
            "CI" => "false",
            "K_SOUP_COV_MULTI_FORMATTERS" => ""
          )
        end
      end

      it "sets MULTI_FORMATTERS_DEFAULT" do
        expect(described_class::MULTI_FORMATTERS_DEFAULT).to eq("true")
      end
    end

    context "when K_SOUP_COV_MULTI_FORMATTERS malformed with extra spaces" do
      before do
        reset_soup_cover_constants do
          stub_env(
            "CI" => "false",
            "K_SOUP_COV_MULTI_FORMATTERS" => "true",
            "K_SOUP_COV_FORMATTERS" => "html, xml, rcov, lcov, json, tty",
            "MAX_ROWS" => nil
          )
        end
      end

      it "sets MULTI_FORMATTERS_DEFAULT" do
        expect(described_class::MULTI_FORMATTERS_DEFAULT).to eq("true")
      end

      it "sets MULTI_FORMATTERS" do
        expect(described_class::MULTI_FORMATTERS).to be(true)
      end

      it "sets FORMATTERS" do
        expect(described_class::FORMATTERS).to eq(
          [
            {klass: "HTMLFormatter", lib: "simplecov-html", type: :html},
            {
              klass: "CoberturaFormatter",
              lib: "simplecov-cobertura",
              type: :xml
            },
            {klass: "RcovFormatter", lib: "simplecov-rcov", type: :rcov},
            {klass: "LcovFormatter", lib: "simplecov_lcov_formatter", type: :lcov},
            {
              klass: "JSONFormatter",
              lib: "simplecov/formatter/json_formatter",
              type: :json
            },
            {klass: "Console", lib: "simplecov-console", type: :tty}
          ]
        )
      end
    end
  end

  it "has constant COMMAND_NAME" do
    expect(described_class::COMMAND_NAME).to be_a(String)
  end

  it "has constant SIMPLECOV_COMMAND_NAME" do
    expect(described_class::SIMPLECOV_COMMAND_NAME).to be_a(String)
  end

  it "has constant COVERAGE_DIR" do
    expect(described_class::COVERAGE_DIR).to be_a(String)
  end

  context "when debugging" do
    before do
      reset_soup_cover_constants do
        stub_env("K_SOUP_COV_DEBUG" => "true")
      end
    end

    it "has constant DEBUG" do
      expect(described_class::DEBUG).to be(true)
    end
  end

  context "when not debugging" do
    before do
      reset_soup_cover_constants do
        stub_env("K_SOUP_COV_DEBUG" => "false")
      end
    end

    it "has constant DEBUG" do
      expect(described_class::DEBUG).to be(false)
    end
  end

  context "when K_SOUP_COV_OPEN_BIN=''" do
    before do
      reset_soup_cover_constants do
        stub_env("K_SOUP_COV_OPEN_BIN" => "")
      end
    end

    it "sets OPEN_BIN" do
      expect(described_class::OPEN_BIN).to eq("")
    end
  end

  context "when K_SOUP_COV_OPEN_BIN='xdg-open'" do
    before do
      reset_soup_cover_constants do
        stub_env("K_SOUP_COV_OPEN_BIN" => "xdg-open")
      end
    end

    it "sets OPEN_BIN" do
      expect(described_class::OPEN_BIN).to eq("xdg-open")
    end
  end

  context "when K_SOUP_COV_OPEN_BIN is not set or nil" do
    context "when macOS" do
      before do
        reset_soup_cover_constants do
          allow(RbConfig::CONFIG).to receive(:[]).with("host_os").and_return("darwin")
          stub_env("K_SOUP_COV_OPEN_BIN" => nil)
        end
      end

      it "sets OPEN_BIN according to RbConfig::Config['host_os']" do
        expect(described_class::OPEN_BIN).to eq("open")
      end
    end

    context "when not macOS" do
      before do
        reset_soup_cover_constants do
          allow(RbConfig::CONFIG).to receive(:[]).with("host_os").and_return("banana")
          stub_env("K_SOUP_COV_OPEN_BIN" => nil)
        end
      end

      it "sets OPEN_BIN according to RbConfig::Config['host_os']" do
        expect(described_class::OPEN_BIN).to eq("xdg-open")
      end
    end
  end
end
