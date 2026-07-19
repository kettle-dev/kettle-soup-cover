# frozen_string_literal: true

# USAGE:
# In your `spec/spec_helper.rb`,
# just prior to loading the library under test:
#
#   require "kettle-soup-cover"
#   # ... other setup code
#   require "simplecov" if Kettle::Soup::Cover::DO_COV
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

# Standard Lib
require "fileutils"
require "json"
require "rbconfig"

# External gems
require "kettle/wash"

# This gem
require_relative "cover/version"

require_relative "cover/constants"
require_relative "cover/loaders"
require_relative "cover/formatters"

module Kettle
  module Soup
    module Cover
      class Error < StandardError; end

      # Provide a public API for constants that is a bit less namespaced
      include Constants
      extend Loaders

      module_function

      VAR_HOME_PREFIX = %r{\A/var/home(?=/|\z)}
      CONSTANTS_PATH = File.expand_path("cover/constants.rb", __dir__)
      LOADERS_PATH = File.expand_path("cover/loaders.rb", __dir__)

      def display_path(path)
        return path if path.nil?

        path.to_s.sub(VAR_HOME_PREFIX, "/home")
      end

      def reset_const(&block)
        if const_defined?(:Constants, false)
          Constants.reset_const(&block)
        else
          block&.call
          load(CONSTANTS_PATH)
          include Constants

          load(LOADERS_PATH) unless const_defined?(:Loaders, false)
          extend Loaders
        end
      end

      def delete_const(&block)
        Constants.delete_const(&block)
      end

      # Deletes coverage/.resultset.json (if it exists) so that stale entries
      # from prior runs cannot pollute the current run's coverage report.
      # Called automatically from config.rb when CLEAN_RESULTSET is true.
      def clean_resultset!
        resultset_path = SimpleCov::ResultMerger.resultset_path
        File.delete(resultset_path) if File.exist?(resultset_path)
      end

      def clear_coverage_dir!(coverage_dir = Constants::COVERAGE_DIR, project_root: Dir.pwd)
        FileUtils.rm_rf(File.expand_path(coverage_dir, project_root))
      end

      def turbo_tests_coverage_dir(coverage_dir = Constants::COVERAGE_ROOT_DIR, project_root: Dir.pwd)
        File.expand_path(File.join(coverage_dir, Constants::TURBO_TESTS_DIR), project_root)
      end

      def turbo_tests_coverage?
        Constants::DO_COV && Constants::TURBO_TESTS
      end

      def clear_turbo_tests_coverage_dir!(coverage_dir = Constants::COVERAGE_ROOT_DIR, project_root: Dir.pwd)
        FileUtils.rm_rf(turbo_tests_coverage_dir(coverage_dir, project_root: project_root))
      end

      def turbo_tests_resultset_paths(coverage_dir = Constants::COVERAGE_ROOT_DIR, project_root: Dir.pwd)
        Dir[File.join(turbo_tests_coverage_dir(coverage_dir, project_root: project_root), "*", ".resultset.json")]
      end

      def turbo_tests_json_paths(coverage_dir = Constants::COVERAGE_ROOT_DIR, project_root: Dir.pwd)
        Dir[File.join(turbo_tests_coverage_dir(coverage_dir, project_root: project_root), "*", "coverage.json")]
      end

      def collate_turbo_tests_coverage!(coverage_dir = Constants::COVERAGE_ROOT_DIR, project_root: Dir.pwd)
        return :disabled unless turbo_tests_coverage?

        resultsets = turbo_tests_resultset_paths(coverage_dir, project_root: project_root)
        return :empty if resultsets.empty?

        require "simplecov"

        SimpleCov.collate(resultsets) do
          command_name("#{Constants::COMMAND_NAME} (turbo_tests2)")
          enable_coverage(:branch)
          primary_coverage(:branch)
          skip(Constants::FILTER_DIRS)
          coverage_dir(File.expand_path(coverage_dir, project_root))

          Kettle::Soup::Cover.configure_formatters!

          if Constants::MIN_COVERAGE_HARD
            minimum_coverage(
              branch: Constants::MIN_COVERAGE_BRANCH,
              line: Constants::MIN_COVERAGE_LINE
            )
          end
        end

        publish_turbo_tests_json_coverage!(coverage_dir, project_root: project_root)

        :collated
      end

      def publish_turbo_tests_json_coverage!(coverage_dir = Constants::COVERAGE_ROOT_DIR, project_root: Dir.pwd)
        paths = turbo_tests_json_paths(coverage_dir, project_root: project_root)
        return :empty if paths.empty?

        merged = {
          "meta" => {},
          "coverage" => {}
        }
        paths.sort_by { |path| File.basename(File.dirname(path)).to_i }.each do |path|
          data = JSON.parse(File.read(path))
          merged["meta"].merge!(data["meta"]) if data["meta"].is_a?(Hash)
          merge_json_coverage!(merged["coverage"], data["coverage"] || {})
        end

        output_path = File.expand_path(File.join(coverage_dir, "coverage.json"), project_root)
        FileUtils.mkdir_p(File.dirname(output_path))
        File.write(output_path, JSON.pretty_generate(merged))
        :published
      end

      def merge_json_coverage!(target, source)
        source.each do |path, coverage|
          target[path] ||= {"lines" => [], "branches" => []}
          target[path]["lines"] = merge_line_coverage(target[path]["lines"], coverage["lines"] || [])
          target[path]["branches"] = merge_branch_coverage(target[path]["branches"] || [], coverage["branches"] || [])
        end
        target
      end

      def merge_line_coverage(left, right)
        length = [left.length, right.length].max
        Array.new(length) { |index| merge_coverage_value(left[index], right[index]) }
      end

      def merge_branch_coverage(left, right)
        length = [left.length, right.length].max
        Array.new(length) { |index| merge_branch_entry(left[index], right[index]) }.compact
      end

      def merge_branch_entry(left, right)
        return right unless left
        return left unless right
        return left unless left.is_a?(Hash) && right.is_a?(Hash)

        left.merge(right) do |key, left_value, right_value|
          (key == "coverage") ? merge_coverage_value(left_value, right_value) : left_value
        end
      end

      def merge_coverage_value(left, right)
        return left + right if left.is_a?(Integer) && right.is_a?(Integer)
        return left if left.is_a?(Integer)
        return right if right.is_a?(Integer)
        return left if left

        right
      end

      def coverage_task_env(coverage_dir = Constants::COVERAGE_DIR, project_root: Dir.pwd)
        resolved_coverage_dir = File.expand_path(coverage_dir, project_root)

        {
          "K_SOUP_COV_PREFIX" => Constants::PREFIX,
          "#{Constants::PREFIX}DIR" => resolved_coverage_dir,
          "#{Constants::PREFIX}DO" => Constants::TRUE,
          "#{Constants::PREFIX}FORMATTERS" => "json",
          "#{Constants::PREFIX}MIN_HARD" => Constants::FALSE,
          "#{Constants::PREFIX}MULTI_FORMATTERS" => Constants::TRUE,
          "#{Constants::PREFIX}OPEN_BIN" => ""
        }
      end

      def refresh_coverage_data!(coverage_dir = Constants::COVERAGE_DIR, project_root: Dir.pwd, out: $stdout, err: $stderr)
        clear_coverage_dir!(coverage_dir, project_root: project_root)

        coverage_task = File.expand_path("bin/rake", project_root)
        success = system(
          coverage_task_env(coverage_dir, project_root: project_root),
          coverage_task,
          "coverage",
          chdir: project_root,
          out: out,
          err: err
        )
        return if success

        raise Error, "Coverage refresh failed: #{coverage_task} coverage"
      end
    end
  end
end
