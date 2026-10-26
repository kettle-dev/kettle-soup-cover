# frozen_string_literal: true

module Kettle
  module Soup
    module Cover
      # Applies the selected SimpleCov minimum coverage policy.
      module CoverageThresholds
        module_function

        def configure!(configuration)
          return unless Constants::MIN_COVERAGE_HARD
          return configure_strict!(configuration) if Constants::MIN_COVERAGE_STRICT

          configuration.minimum_coverage(
            branch: Constants::MIN_COVERAGE_BRANCH,
            line: Constants::MIN_COVERAGE_LINE
          )
        end

        def configure_strict!(configuration)
          configuration.enable_coverage(:branch)
          configuration.enable_coverage(:method)
          if SimpleCov::Configuration.method_defined?(:coverage_for_eval_supported?) &&
              configuration.coverage_for_eval_supported?
            configuration.enable_coverage(:eval)
          end
          configuration.minimum_coverage(line: 100, branch: 100, method: 100)
        end
      end
    end
  end
end
