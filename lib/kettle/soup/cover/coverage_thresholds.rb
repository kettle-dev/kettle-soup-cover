# frozen_string_literal: true

module Kettle
  module Soup
    module Cover
      module CoverageThresholds
        module_function

        def configure!(configuration)
          return unless Constants::MIN_COVERAGE_HARD

          if Constants::MIN_COVERAGE_STRICT
            unless SimpleCov.respond_to?(:profiles)
              raise "Strict coverage requires a SimpleCov version with profile support"
            end

            configuration.instance_exec(&SimpleCov.profiles.fetch_proc(:strict))
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
