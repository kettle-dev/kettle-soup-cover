# frozen_string_literal: true

RSpec.describe Kettle::Soup::Cover::Constants do
  include_context "with stubbed env"
  include_context "with hidden env"

  describe "CI" do
    before do
      described_class.reset_const do
        stub_env("CI" => ci)
        stub_env("K_SOUP_COV_MULTI_FORMATTERS" => multi_formatters)
        stub_env("TEST_ENV_NUMBER" => "")
      end
    end

    let(:ci) { "true" }
    let(:multi_formatters) { "" }

    it "succeeds" do
      block_is_expected.not_to raise_error
    end

    context "when CI=true" do
      it "sets CI=true" do
        expect(described_class::CI).to eq("true")
      end
    end

    context "when CI=false" do
      let(:ci) { "false" }

      it "sets CI=false" do
        expect(described_class::CI).to eq("false")
      end

      it "sets MULTI_FORMATTERS" do
        expect(described_class::MULTI_FORMATTERS).to be(false)
      end
    end
  end

  describe "FORMATTERS" do
    context "when CI=true and formatter names are defaulted" do
      before do
        described_class.reset_const do
          stub_env("CI" => "true")
          stub_env("K_SOUP_COV_FORMATTERS" => nil)
          stub_env("K_SOUP_COV_MULTI_FORMATTERS" => nil)
          stub_env("MAX_ROWS" => nil)
          stub_env("TEST_ENV_NUMBER" => "")
        end
      end

      it "uses the CI formatter list" do
        expect(described_class::FORMATTERS.map { |formatter| formatter.fetch(:type) }).to eq(
          %i[html xml rcov lcov json tty]
        )
      end
    end

    context "when MAX_ROWS is set but not zero" do
      before do
        described_class.reset_const do
          stub_env("CI" => "false")
          stub_env("K_SOUP_COV_FORMATTERS" => "html,tty")
          stub_env("MAX_ROWS" => "5")
          stub_env("TEST_ENV_NUMBER" => "")
        end
      end

      it "keeps the tty formatter" do
        expect(described_class::FORMATTERS.map { |formatter| formatter.fetch(:type) }).to eq(%i[html tty])
      end
    end

    context "when no configured formatter names are recognized" do
      before do
        described_class.reset_const do
          stub_env("CI" => "false")
          stub_env("K_SOUP_COV_FORMATTERS" => "unknown")
          stub_env("K_SOUP_COV_MULTI_FORMATTERS" => nil)
          stub_env("TEST_ENV_NUMBER" => "")
        end
      end

      it "has no formatter plugins" do
        expect(described_class::FORMATTERS).to be_empty
      end

      it "defaults multi formatter mode to false" do
        expect(described_class::MULTI_FORMATTERS_DEFAULT).to eq("false")
      end
    end
  end

  describe "MULTI_FORMATTERS_DEFAULT" do
    context "when CI=true" do
      before do
        described_class.reset_const do
          stub_env("CI" => "true")
          stub_env("K_SOUP_COV_FORMATTERS" => nil)
          stub_env("K_SOUP_COV_MULTI_FORMATTERS" => nil)
          stub_env("TEST_ENV_NUMBER" => "")
        end
      end

      it "defaults to true" do
        expect(described_class::MULTI_FORMATTERS_DEFAULT).to eq("true")
      end
    end

    context "when no formatters are configured outside CI" do
      before do
        described_class.reset_const do
          stub_env("CI" => "false")
          stub_env("K_SOUP_COV_FORMATTERS" => "unknown")
          stub_env("K_SOUP_COV_MULTI_FORMATTERS" => nil)
          stub_env("TEST_ENV_NUMBER" => "")
        end
      end

      it "defaults to false" do
        expect(described_class::MULTI_FORMATTERS_DEFAULT).to eq("false")
      end
    end
  end

  describe "MIN_COVERAGE_HARD" do
    before do
      described_class.reset_const do
        stub_env("CI" => ci)
        stub_env("K_SOUP_COV_MULTI_FORMATTERS" => "false")
        stub_env("TEST_ENV_NUMBER" => "")
        if min_hard.nil?
          hide_env("K_SOUP_COV_MIN_HARD")
        else
          stub_env("K_SOUP_COV_MIN_HARD" => min_hard)
        end
      end
    end

    let(:ci) { "true" }
    let(:min_hard) { nil } # nil means not set (use default)

    context "when CI=true and K_SOUP_COV_MIN_HARD is not set" do
      let(:ci) { "true" }
      let(:min_hard) { nil }

      it "defaults to true (CI behavior)" do
        expect(described_class::MIN_COVERAGE_HARD).to be(true)
      end
    end

    context "when CI=true and K_SOUP_COV_MIN_HARD=true" do
      let(:ci) { "true" }
      let(:min_hard) { "true" }

      it "is true" do
        expect(described_class::MIN_COVERAGE_HARD).to be(true)
      end
    end

    context "when CI=true and K_SOUP_COV_MIN_HARD=false" do
      let(:ci) { "true" }
      let(:min_hard) { "false" }

      it "is false (explicit override)" do
        expect(described_class::MIN_COVERAGE_HARD).to be(false)
      end
    end

    context "when CI=false and K_SOUP_COV_MIN_HARD is not set" do
      let(:ci) { "false" }
      let(:min_hard) { nil }

      it "defaults to false (non-CI behavior)" do
        expect(described_class::MIN_COVERAGE_HARD).to be(false)
      end
    end

    context "when CI=false and K_SOUP_COV_MIN_HARD=true" do
      let(:ci) { "false" }
      let(:min_hard) { "true" }

      it "is true (explicit override)" do
        expect(described_class::MIN_COVERAGE_HARD).to be(true)
      end
    end

    context "when CI=false and K_SOUP_COV_MIN_HARD=false" do
      let(:ci) { "false" }
      let(:min_hard) { "false" }

      it "is false" do
        expect(described_class::MIN_COVERAGE_HARD).to be(false)
      end
    end
  end

  describe "CLEAN_RESULTSET" do
    before do
      described_class.reset_const do
        stub_env("CI" => ci)
        stub_env("K_SOUP_COV_MULTI_FORMATTERS" => "false")
        stub_env("TEST_ENV_NUMBER" => "")
        if clean_resultset.nil?
          hide_env("K_SOUP_COV_CLEAN_RESULTSET")
        else
          stub_env("K_SOUP_COV_CLEAN_RESULTSET" => clean_resultset)
        end
      end
    end

    let(:clean_resultset) { nil }

    context "when CI=true and K_SOUP_COV_CLEAN_RESULTSET is not set" do
      let(:ci) { "true" }

      it "defaults to false (CI workspaces are already clean)" do
        expect(described_class::CLEAN_RESULTSET).to be(false)
      end
    end

    context "when CI=false and K_SOUP_COV_CLEAN_RESULTSET is not set" do
      let(:ci) { "false" }

      it "defaults to true (local devs re-run tests frequently)" do
        expect(described_class::CLEAN_RESULTSET).to be(true)
      end
    end

    context "when CI=true and K_SOUP_COV_CLEAN_RESULTSET=true" do
      let(:ci) { "true" }
      let(:clean_resultset) { "true" }

      it "is true (explicit override)" do
        expect(described_class::CLEAN_RESULTSET).to be(true)
      end
    end

    context "when CI=false and K_SOUP_COV_CLEAN_RESULTSET=false" do
      let(:ci) { "false" }
      let(:clean_resultset) { "false" }

      it "is false (explicit override)" do
        expect(described_class::CLEAN_RESULTSET).to be(false)
      end
    end
  end

  describe "OPEN_BIN" do
    context "when host OS is macOS and no override is set" do
      before do
        described_class.reset_const do
          allow(RbConfig::CONFIG).to receive(:[]).with("host_os").and_return("darwin")
          stub_env("K_SOUP_COV_OPEN_BIN" => nil)
        end
      end

      it "defaults to open" do
        expect(described_class::OPEN_BIN).to eq("open")
      end
    end
  end

  describe "turbo_tests2 coverage" do
    before do
      described_class.reset_const do
        stub_env("CI" => "false")
        stub_env("K_SOUP_COV_DIR" => "coverage")
        stub_env("K_SOUP_COV_MIN_HARD" => "false")
        stub_env("K_SOUP_COV_TURBO_TESTS" => turbo_tests)
        stub_env("K_SOUP_COV_TURBO_TESTS_DIR" => "parallel")
        stub_env("TEST_ENV_NUMBER" => test_env_number)
      end
    end

    let(:turbo_tests) { "true" }
    let(:test_env_number) { "2" }

    it "uses an isolated worker coverage directory with a unique worker command name" do
      expect(described_class::COVERAGE_ROOT_DIR).to eq("coverage")
      expect(described_class::COVERAGE_DIR).to eq("coverage/parallel/2")
      expect(described_class::SIMPLECOV_COMMAND_NAME).to eq("#{described_class::COMMAND_NAME} (turbo_tests2 worker 2)")
      expect(described_class::TURBO_TESTS_WORKER).to be(true)
      expect(described_class::CLEAN_RESULTSET).to be(false)
    end

    it "disables worker-level hard minimums while preserving the requested setting" do
      expect(described_class::MIN_COVERAGE_HARD_REQUESTED).to be(false)
      expect(described_class::MIN_COVERAGE_HARD).to be(false)
    end

    context "when hard minimums are requested" do
      before do
        described_class.reset_const do
          stub_env("CI" => "true")
          stub_env("K_SOUP_COV_DIR" => "coverage")
          stub_env("K_SOUP_COV_MIN_HARD" => "true")
          stub_env("K_SOUP_COV_TURBO_TESTS" => turbo_tests)
          stub_env("K_SOUP_COV_TURBO_TESTS_DIR" => "parallel")
          stub_env("TEST_ENV_NUMBER" => test_env_number)
        end
      end

      it "defers hard minimum enforcement to the collated parent process" do
        expect(described_class::MIN_COVERAGE_HARD_REQUESTED).to be(true)
        expect(described_class::MIN_COVERAGE_HARD).to be(false)
      end
    end

    context "when turbo_tests2 coverage is disabled" do
      let(:turbo_tests) { "false" }

      it "keeps the root coverage directory" do
        expect(described_class::COVERAGE_DIR).to eq("coverage")
        expect(described_class::SIMPLECOV_COMMAND_NAME).to eq(described_class::COMMAND_NAME)
        expect(described_class::TURBO_TESTS_WORKER).to be(false)
      end
    end
  end
end
