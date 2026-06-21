# frozen_string_literal: true

namespace :turbo_tests do
  desc "Prepare shared SimpleCov coverage output for turbo_tests2 workers"
  task :setup do
    if Kettle::Soup::Cover.turbo_tests_coverage?
      Kettle::Soup::Cover.clear_coverage_dir!
    end
  end

  desc "Collate turbo_tests2 worker coverage reports"
  task :cleanup do
    Kettle::Soup::Cover.collate_turbo_tests_coverage!
  end
end

namespace :turbo_tests2 do
  desc "Prepare shared SimpleCov coverage output for turbo_tests2 workers"
  task setup: "turbo_tests:setup"

  desc "Collate turbo_tests2 worker coverage reports"
  task cleanup: "turbo_tests:cleanup"
end
