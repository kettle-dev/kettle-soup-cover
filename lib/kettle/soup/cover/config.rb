# frozen_string_literal: true

# USAGE:
# In your `spec/spec_helper.rb`,
# just prior to loading the library under test:
#
#   require "kettle-soup-cover"
#
# In your `.simplecov` file:
#
#   require "kettle/soup/cover/config"
#
# In your `spec/spec_helper.rb`,
# after requiring SimpleCov:
#
#   SimpleCov.start
#

require_relative "constants" unless defined?(Kettle::Soup::Cover::Constants)
require_relative "loaders" unless defined?(Kettle::Soup::Cover::Loaders)
require_relative "formatters" unless defined?(Kettle::Soup::Cover) && Kettle::Soup::Cover.respond_to?(:configure_formatters!)

SimpleCov.configure do
  cover("lib/**/*.rb")

  command_name Kettle::Soup::Cover::Constants::COMMAND_NAME

  enable_coverage :branch
  primary_coverage :branch

  # Filters (skip these paths for coverage tracking)
  skip Kettle::Soup::Cover::Constants::FILTER_DIRS

  # Setup Coverage Dir
  coverage_dir(Kettle::Soup::Cover::Constants::COVERAGE_DIR)

  # Formatters
  Kettle::Soup::Cover.configure_formatters!

  # Use Merging (merges coverage from multiple test runs, e.g., RSpec + Cucumber Test Results)
  # This is essential for projects that split tests into multiple rake tasks
  # (e.g., FFI specs, integration specs, unit specs run separately)
  merging(Kettle::Soup::Cover::Constants::USE_MERGING) unless Kettle::Soup::Cover::Constants::USE_MERGING.nil?
  merge_timeout(Kettle::Soup::Cover::Constants::MERGE_TIMEOUT) if Kettle::Soup::Cover::Constants::MERGE_TIMEOUT.nonzero?

  # Fail build when missed coverage targets
  # NOTE: Checking SpecTracker.instance.full_suite? here would be awesome, but won't work
  #       SpecTracker must wait for instantiation until it has
  #       RSpec's config.world.all_examples,
  #       and that doesn't happen until the before(:suite) hook
  #
  # MIN_COVERAGE_HARD takes precedence:
  # - If explicitly set to false (K_SOUP_COV_MIN_HARD=false), never enforce minimum coverage
  # - If explicitly set to true (K_SOUP_COV_MIN_HARD=true), always enforce minimum coverage
  # - If not set, defaults to IS_CI (enforce in CI, don't enforce locally)
  if Kettle::Soup::Cover::Constants::MIN_COVERAGE_HARD
    minimum_coverage(
      branch: Kettle::Soup::Cover::Constants::MIN_COVERAGE_BRANCH,
      line: Kettle::Soup::Cover::Constants::MIN_COVERAGE_LINE
    )
  end
end

# Clean up stale resultset entries from prior runs before SimpleCov.start.
# See Kettle::Soup::Cover::Constants::CLEAN_RESULTSET for default behavior.
if Kettle::Soup::Cover::Constants::CLEAN_RESULTSET && Kettle::Soup::Cover.respond_to?(:clean_resultset!)
  Kettle::Soup::Cover.clean_resultset!
end
