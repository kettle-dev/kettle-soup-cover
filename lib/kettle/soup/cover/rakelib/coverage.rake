# NOTE: This is not for CI, only for local development.
require "kettle/wash"
require "shellwords"

constants_path = File.expand_path("../constants.rb", __dir__)
load constants_path unless Kettle::Soup::Cover::Constants.const_defined?(:WASHED_CONSTANTS, false)
washed_constants = Kettle::Soup::Cover::Constants::WASHED_CONSTANTS

desc "Run specs w/ coverage and open results in browser"
task :coverage do
  ENV["K_SOUP_COV_PREFIX"] = "K_SOUP_COV_"
  ENV["K_SOUP_COV_DO"] = "true"
  ENV["K_SOUP_COV_MULTI_FORMATTERS"] = "true"
  ENV["K_SOUP_COV_FORMATTERS"] ||= "html"
  ENV["K_SOUP_COV_DIR"] ||= "coverage"
  Kettle::Wash.reset_constants(owner: Kettle::Soup::Cover::Constants, **washed_constants)

  Rake::Task["test"].invoke
  html_report = "#{Kettle::Soup::Cover::COVERAGE_DIR}/index.html"
  if Kettle::Soup::Cover::OPEN_BIN.empty?
    puts "Kettle::Soup::Cover::OPEN_BIN not configured. Coverage report is at #{Kettle::Soup::Cover.display_path(html_report)}"
  elsif !File.exist?(html_report)
    puts "No coverage report found at #{Kettle::Soup::Cover.display_path(html_report)}"
  else
    open_command = Shellwords.split(Kettle::Soup::Cover::OPEN_BIN)
    opened = system(*open_command, html_report)
    unless opened
      puts "Configured Kettle::Soup::Cover::OPEN_BIN (#{Kettle::Soup::Cover::OPEN_BIN}) not available. Coverage report is at #{Kettle::Soup::Cover.display_path(html_report)}"
    end
  end
end
