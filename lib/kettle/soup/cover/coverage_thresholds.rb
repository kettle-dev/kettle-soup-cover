# frozen_string_literal: true

module Kettle
  module Soup
    module Cover
      # Applies the selected SimpleCov minimum coverage policy.
      module CoverageThresholds
        module_function

        def configure!(configuration)
          configure_strict_criteria!(configuration)
          configure_minimum!(configuration) if Constants::MIN_COVERAGE_HARD
        end

        def configure_strict_criteria!(configuration)
          return unless Constants::MIN_COVERAGE_STRICT

          configuration.enable_coverage(:branch)
          configuration.enable_coverage(:method)
          if SimpleCov::Configuration.method_defined?(:coverage_for_eval_supported?) &&
              configuration.coverage_for_eval_supported?
            configuration.enable_coverage(:eval)
          end
        end

        def configure_minimum!(configuration)
          if Constants::MIN_COVERAGE_STRICT
            configuration.minimum_coverage(line: 100, branch: 100, method: 100)
          else
            # SimpleCov's `minimum_coverage(hash)` replaces the whole minimums
            # Hash, so merge into the minimums already configured (for example
            # by the project's .simplecov) instead of dropping or lowering them.
            configuration.minimum_coverage(
              merge_minimum_coverage(
                configuration.minimum_coverage,
                branch: Constants::MIN_COVERAGE_BRANCH,
                line: Constants::MIN_COVERAGE_LINE
              )
            )
          end
        end

        # Merges minimums into minimums that are already configured.
        #
        # For each criterion the higher of the two values wins, so a minimum
        # the project set itself is never lowered. Criteria only `existing`
        # has, such as method coverage, are kept as they are.
        #
        # @param existing [Hash{Symbol => Numeric}] the current minimums, as
        #   answered by SimpleCov's `minimum_coverage` reader (empty when
        #   nothing is configured)
        # @param minimums [Hash{Symbol => Numeric}] the minimums to merge in
        # @return [Hash{Symbol => Numeric}] a new Hash (`existing` is left unmodified)
        def merge_minimum_coverage(existing, minimums)
          existing.merge(minimums) do |_criterion, current, minimum|
            [current, minimum].compact.max
          end
        end
      end
    end
  end
end
