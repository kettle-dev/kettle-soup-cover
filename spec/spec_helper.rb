# frozen_string_literal: true

# External RSpec & related config
require "kettle/test/rspec"

# Usage:
#   see https://github.com/pboling/rspec-block_is_expected#example
require "rspec/block_is_expected"
require "rspec/block_is_expected/matchers/not"

# Usage:
# describe 'my stubbed test' do
#   include_context 'with stubbed env'
#   before do
#     stub_env('FOO' => 'is bar')
#   end
#   it 'has a value' do
#     expect(ENV['FOO']).to eq('is bar')
#   end
# end
require "rspec/stubbed_env"
require "fileutils"
require "stringio"

# External gems
require "version_gem/rspec"
require "rake"

# RSpec Configs
require "config/rspec/rspec_core"
require "config/rspec/silent_stream"

# Force load the cover module, so we can use it while testing it, and get accurate coverage.
# It will be reloaded again after simplecov begins tracking.
path = File.expand_path(__dir__)
load File.join(path, "..", "lib", "kettle", "change.rb")
load File.join(path, "..", "lib", "kettle", "soup", "cover", "constants.rb")
load File.join(path, "..", "lib", "kettle", "soup", "cover", "loaders.rb")

# SimpleCov
# Normally we would only load simple cov if checking test coverage,
#   but our runtime code depends on simplecov, so loading it is non-optional.
# Our run-time code does not itself require simplecov,
#   because that comes with side effects that must be delayed until coverage tracking should begin.
require "simplecov"
SimpleCov.start if ENV.fetch("K_SOUP_COV_DO", "false").casecmp?("true")
if defined?(Kettle::Soup::Cover)
  cover_module = Kettle::Soup::Cover
  if cover_module.private_method_defined?(:configure_formatters!, false)
    cover_module.send(:remove_method, :configure_formatters!)
  end
  singleton_class = cover_module.singleton_class
  if singleton_class.method_defined?(:configure_formatters!) || singleton_class.private_method_defined?(:configure_formatters!)
    singleton_class.send(:remove_method, :configure_formatters!)
  end
end
load File.join(path, "..", "lib", "kettle", "soup", "cover", "formatters.rb")

# rubocop:disable RSpec/RemoveConst
Kettle.send(:remove_const, :Change) if Kettle.const_defined?(:Change, false)
if Kettle.const_defined?(:Soup, false) && Kettle::Soup.const_defined?(:Cover, false)
  Kettle::Soup::Cover.send(:remove_const, :Constants) if Kettle::Soup::Cover.const_defined?(:Constants, false)
  Kettle::Soup::Cover.send(:remove_const, :Loaders) if Kettle::Soup::Cover.const_defined?(:Loaders, false)
end
# rubocop:enable RSpec/RemoveConst

# This gem
require "kettle-soup-cover"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.after(:suite) do
    # These rake task files are intentionally reloaded by their specs into isolated
    # Rake applications. Ruby branch coverage keeps the counters from the final
    # load, so exercise both task branches once after randomized examples finish.
    original_application = Rake.application
    original_stdout = $stdout
    original_stderr = $stderr
    original_ci = ENV.fetch("CI", nil)
    original_formatters = ENV.fetch("K_SOUP_COV_FORMATTERS", nil)
    original_host_os = RbConfig::CONFIG["host_os"]
    original_max_rows = ENV.fetch("MAX_ROWS", nil)
    original_open_bin = ENV.fetch("K_SOUP_COV_OPEN_BIN", nil)
    original_test_env_number = ENV.fetch("TEST_ENV_NUMBER", nil)
    original_turbo_tests = ENV.fetch("K_SOUP_COV_TURBO_TESTS", nil)
    original_coverage_dir = ENV.fetch("K_SOUP_COV_DIR", nil)

    begin
      $stdout = StringIO.new
      $stderr = StringIO.new
      ENV["K_SOUP_COV_DIR"] = File.join("tmp", "spec-helper-coverage")
      html_report = File.join(ENV.fetch("K_SOUP_COV_DIR"), "index.html")
      FileUtils.mkdir_p(File.dirname(html_report))
      File.write(html_report, "")

      Rake.application = Rake::Application.new
      load File.expand_path("../lib/kettle/soup/cover/rakelib/turbo_tests.rake", __dir__)

      ENV["K_SOUP_COV_TURBO_TESTS"] = "true"
      Kettle::Soup::Cover.reset_const
      Rake.application["turbo_tests:setup"].invoke

      ENV["K_SOUP_COV_TURBO_TESTS"] = "false"
      Kettle::Soup::Cover.reset_const
      Rake.application["turbo_tests:setup"].reenable
      Rake.application["turbo_tests:setup"].invoke
      ENV["K_SOUP_COV_TURBO_TESTS"] = "true"
      Kettle::Soup::Cover.reset_const
      Rake.application["turbo_tests:cleanup"].invoke

      ENV["CI"] = "true"
      ENV["MAX_ROWS"] = "0"
      ENV["TEST_ENV_NUMBER"] = ""
      Kettle::Soup::Cover.reset_const
      ENV["CI"] = "false"
      ENV.delete("MAX_ROWS")
      ENV["K_SOUP_COV_TURBO_TESTS"] = "false"
      Kettle::Soup::Cover.reset_const
      Kettle::Soup::Cover.delete_const {}

      Rake.application = Rake::Application.new
      load File.expand_path("config/mocks/test_task.rake", __dir__)
      load File.expand_path("../lib/kettle/soup/cover/rakelib/coverage.rake", __dir__)

      ["", "blah", "blah --bad", "true --ignored"].each do |open_bin|
        ENV["K_SOUP_COV_OPEN_BIN"] = open_bin
        Kettle::Soup::Cover.reset_const
        Rake.application["coverage"].reenable
        Rake.application["test"].reenable
        Rake.application["coverage"].invoke
      end
      FileUtils.rm_f(html_report)
      ENV["K_SOUP_COV_OPEN_BIN"] = "false --ignored"
      Kettle::Soup::Cover.reset_const
      Rake.application["coverage"].reenable
      Rake.application["test"].reenable
      Rake.application["coverage"].invoke

      case original_test_env_number
      when "1"
        ENV["CI"] = "true"
        ENV.delete("K_SOUP_COV_FORMATTERS")
        ENV.delete("MAX_ROWS")
        ENV["K_SOUP_COV_TURBO_TESTS"] = "false"
        ENV["TEST_ENV_NUMBER"] = ""
        RbConfig::CONFIG["host_os"] = "darwin"
      when "2"
        ENV["CI"] = "false"
        ENV["K_SOUP_COV_FORMATTERS"] = "unknown"
        ENV.delete("MAX_ROWS")
        ENV["K_SOUP_COV_TURBO_TESTS"] = "false"
        ENV["TEST_ENV_NUMBER"] = ""
      else
        ENV["CI"] = "false"
        ENV["K_SOUP_COV_FORMATTERS"] = "html,tty"
        ENV["MAX_ROWS"] = "0"
        ENV["K_SOUP_COV_TURBO_TESTS"] = "true"
        ENV["TEST_ENV_NUMBER"] = original_test_env_number unless original_test_env_number.nil?
      end
      Kettle::Soup::Cover.reset_const
    ensure
      Rake.application = original_application
      $stdout = original_stdout
      $stderr = original_stderr
      RbConfig::CONFIG["host_os"] = original_host_os
      if original_ci.nil?
        ENV.delete("CI")
      else
        ENV["CI"] = original_ci
      end
      if original_formatters.nil?
        ENV.delete("K_SOUP_COV_FORMATTERS")
      else
        ENV["K_SOUP_COV_FORMATTERS"] = original_formatters
      end
      if original_max_rows.nil?
        ENV.delete("MAX_ROWS")
      else
        ENV["MAX_ROWS"] = original_max_rows
      end
      if original_open_bin.nil?
        ENV.delete("K_SOUP_COV_OPEN_BIN")
      else
        ENV["K_SOUP_COV_OPEN_BIN"] = original_open_bin
      end
      if original_test_env_number.nil?
        ENV.delete("TEST_ENV_NUMBER")
      else
        ENV["TEST_ENV_NUMBER"] = original_test_env_number
      end
      if original_turbo_tests.nil?
        ENV.delete("K_SOUP_COV_TURBO_TESTS")
      else
        ENV["K_SOUP_COV_TURBO_TESTS"] = original_turbo_tests
      end
      if original_coverage_dir.nil?
        ENV.delete("K_SOUP_COV_DIR")
      else
        ENV["K_SOUP_COV_DIR"] = original_coverage_dir
      end
    end
  end
end
