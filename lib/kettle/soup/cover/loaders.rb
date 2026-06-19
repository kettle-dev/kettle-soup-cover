module Kettle
  module Soup
    module Cover
      module Loaders
        extend self

        def load_formatters
          SimpleCov.formatters = Kettle::Soup::Cover::Constants::FORMATTERS
            .each_with_object([]) do |fmt_data, formatters|
            require fmt_data[:lib].to_s

            klass = SimpleCov::Formatter.const_get(fmt_data[:klass])

            if fmt_data[:type] == :lcov
              klass.config do |c|
                c.report_with_single_file = true
                c.single_report_path = "#{Kettle::Soup::Cover::Constants::COVERAGE_DIR}/lcov.info"
              end
            end

            formatters << klass
          end
        end

        def load_filters
          require "kettle/soup/cover/filters/gt_line_filter"
          require "kettle/soup/cover/filters/lt_line_filter"
        end

        def install_tasks
          load("kettle/soup/cover/tasks.rb")
        end
      end
    end
  end
end
