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
            configuration.minimum_coverage(
              branch: Constants::MIN_COVERAGE_BRANCH,
              line: Constants::MIN_COVERAGE_LINE
            )
          end
        end
      end
    end
  end
end
