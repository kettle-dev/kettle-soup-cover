# frozen_string_literal: true

restore_cover_modules = lambda do
  load File.expand_path("../constants.rb", __dir__) unless Kettle::Soup::Cover.const_defined?(:Constants, false)
  Kettle::Soup::Cover.include(Kettle::Soup::Cover::Constants) unless Kettle::Soup::Cover.ancestors.include?(Kettle::Soup::Cover::Constants)

  load File.expand_path("../loaders.rb", __dir__) unless Kettle::Soup::Cover.const_defined?(:Loaders, false)
  Kettle::Soup::Cover.extend(Kettle::Soup::Cover::Loaders)
end

namespace :turbo_tests do
  desc "Prepare shared SimpleCov coverage output for turbo_tests2 workers"
  task :setup do
    restore_cover_modules.call
    if Kettle::Soup::Cover.turbo_tests_coverage?
      Kettle::Soup::Cover.clear_coverage_dir!
    end
  end

  desc "Collate turbo_tests2 worker coverage reports"
  task :cleanup do
    restore_cover_modules.call
    Kettle::Soup::Cover.collate_turbo_tests_coverage!
  end
end

namespace :turbo_tests2 do
  desc "Prepare shared SimpleCov coverage output for turbo_tests2 workers"
  task setup: "turbo_tests:setup"

  desc "Collate turbo_tests2 worker coverage reports"
  task cleanup: "turbo_tests:cleanup"
end
