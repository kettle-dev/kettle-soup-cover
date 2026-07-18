module Kettle
  module Soup
    module Cover
      module Constants
        FALSE = "false"
        TRUE = "true"
        PREFIX = ENV.fetch("K_SOUP_COV_PREFIX", "K_SOUP_COV_")
        ENV_GET = ->(suffix, default) { ENV.fetch("#{PREFIX}#{suffix}", default) }
        FORMATTER_PLUGINS = {
          # HTML for Humans
          html: {
            type: :html,
            klass: "HTMLFormatter",
            lib: "simplecov-html"
          },
          # XML for Jenkins
          xml: {
            type: :xml,
            klass: "CoberturaFormatter",
            lib: "simplecov-cobertura"
          },
          # RCOV for Hudson
          rcov: {
            type: :rcov,
            klass: "RcovFormatter",
            lib: "simplecov-rcov"
          },
          # LCOV for GCOV
          lcov: {
            type: :lcov,
            klass: "LcovFormatter",
            lib: "simplecov_lcov_formatter"
          },
          # JSON for CodeClimate
          json: {
            type: :json,
            klass: "JSONFormatter",
            lib: "simplecov/formatter/json_formatter"
          },
          # TTY / Console output
          tty: {
            type: :tty,
            klass: "Console",
            lib: "simplecov-console"
          }
        }

        CI = ENV.fetch("CI", Constants::FALSE)
        IS_CI = CI.casecmp?(Constants::TRUE)
        COMMAND_NAME = ENV_GET.call("COMMAND_NAME", "RSpec (COVERAGE)")
        COVERAGE_ROOT_DIR = ENV_GET.call("DIR", "coverage")
        DEBUG = ENV_GET.call("DEBUG", Constants::FALSE).casecmp?(Constants::TRUE)
        DO_COV = ENV_GET.call("DO", CI).casecmp?(Constants::TRUE)
        FILTER_DIRS = ENV_GET.call(
          "FILTER_DIRS",
          "bin,certs,checksums,config,coverage,docs,features,gemfiles,pkg,results,sig,spec,src,test,test-results,vendor"
        )
          .split(",")
          .map { |dir_name| %r{^/#{Regexp.escape(dir_name)}/} }
        FORMATTERS = begin
          list = ENV_GET.call(
            "FORMATTERS",
            IS_CI ? "html,xml,rcov,lcov,json,tty" : "html,tty"
          )
            .split(",")
            .map { |fmt_name| FORMATTER_PLUGINS[fmt_name.strip.to_sym] }
            .compact

          # If MAX_ROWS is explicitly set to "0", skip tty output from simplecov-console
          max_rows = ENV.fetch("MAX_ROWS", nil)
          if max_rows && max_rows.strip == "0"
            list = list.reject { |f| f && f[:type] == :tty }
          end

          list
        end
        MIN_COVERAGE_BRANCH = ENV_GET.call("MIN_BRANCH", "80").to_i
        MIN_COVERAGE_LINE = ENV_GET.call("MIN_LINE", "80").to_i
        MULTI_FORMATTERS_DEFAULT = if IS_CI
          Constants::TRUE
        else
          FORMATTERS.any? ? Constants::TRUE : Constants::FALSE
        end
        MULTI_FORMATTERS = ENV_GET.call("MULTI_FORMATTERS", MULTI_FORMATTERS_DEFAULT).casecmp?(Constants::TRUE)
        TEST_ENV_NUMBER = ENV.fetch("TEST_ENV_NUMBER", "")
        TURBO_TESTS = ENV_GET.call("TURBO_TESTS", Constants::TRUE).casecmp?(Constants::TRUE)
        TURBO_TESTS_DIR = ENV_GET.call("TURBO_TESTS_DIR", "turbo_tests")
        TURBO_TESTS_WORKER = TURBO_TESTS && !TEST_ENV_NUMBER.empty?
        SIMPLECOV_COMMAND_NAME = if TURBO_TESTS_WORKER
          "#{COMMAND_NAME} (turbo_tests2 worker #{TEST_ENV_NUMBER})"
        else
          COMMAND_NAME
        end
        MIN_COVERAGE_HARD_REQUESTED = ENV_GET.call("MIN_HARD", CI).casecmp?(Constants::TRUE)
        MIN_COVERAGE_HARD = MIN_COVERAGE_HARD_REQUESTED && !TURBO_TESTS_WORKER
        COVERAGE_DIR = if TURBO_TESTS_WORKER
          File.join(COVERAGE_ROOT_DIR, TURBO_TESTS_DIR, TEST_ENV_NUMBER)
        else
          COVERAGE_ROOT_DIR
        end
        # A wild approximation, but will suffice for nearly all users
        is_mac = RbConfig::CONFIG["host_os"].include?("darwin")
        # Set to "" to prevent opening a browser with the coverage rake task
        OPEN_BIN = ENV_GET.call("OPEN_BIN", is_mac ? "open" : "xdg-open")
        # Delete coverage/.resultset.json before SimpleCov starts to prevent stale
        # entries from prior runs (which have shifted branch/line IDs after refactors)
        # from polluting the current run's coverage report.
        #
        # Default: true outside CI, false inside CI.
        #   - Outside CI developers re-run tests frequently; stale entries accumulate.
        #   - Inside CI each job starts from a clean workspace, so cleanup is redundant.
        #
        # Override with K_SOUP_COV_CLEAN_RESULTSET=true/false, or set the accessor
        # directly in Ruby before SimpleCov.start.
        #
        # IMPORTANT: set K_SOUP_COV_CLEAN_RESULTSET=false in .simplecov_spawn.rb (or
        # equivalent) so that spawned subprocesses do not wipe the resultset that the
        # main process and sibling spawns are accumulating.
        CLEAN_RESULTSET_DEFAULT = (IS_CI || TURBO_TESTS_WORKER) ? Constants::FALSE : Constants::TRUE
        CLEAN_RESULTSET = ENV_GET.call("CLEAN_RESULTSET", CLEAN_RESULTSET_DEFAULT).casecmp?(Constants::TRUE)
        # Enable merging by default to aggregate coverage across multiple test runs
        # (e.g., separate RSpec tasks for FFI tests, integration tests, unit tests)
        # Set K_SOUP_COV_USE_MERGING=false to disable
        USE_MERGING = ENV_GET.call("USE_MERGING", Constants::TRUE).casecmp?(Constants::TRUE)
        # Default merge timeout of 1 hour (3600 seconds) - enough for most test suites
        # Set K_SOUP_COV_MERGE_TIMEOUT to override
        MERGE_TIMEOUT = ENV_GET.call("MERGE_TIMEOUT", "3600").to_i
        VERBOSE = ENV_GET.call("VERBOSE", Constants::FALSE).casecmp?(Constants::TRUE)

        include Kettle::Change.new(
          constants: %w[
            CI
            CLEAN_RESULTSET
            CLEAN_RESULTSET_DEFAULT
            COMMAND_NAME
            COVERAGE_DIR
            COVERAGE_ROOT_DIR
            DEBUG
            DO_COV
            ENV_GET
            FALSE
            FILTER_DIRS
            FORMATTER_PLUGINS
            FORMATTERS
            IS_CI
            MERGE_TIMEOUT
            MIN_COVERAGE_BRANCH
            MIN_COVERAGE_LINE
            MIN_COVERAGE_HARD
            MIN_COVERAGE_HARD_REQUESTED
            MULTI_FORMATTERS_DEFAULT
            MULTI_FORMATTERS
            OPEN_BIN
            PREFIX
            SIMPLECOV_COMMAND_NAME
            TRUE
            TEST_ENV_NUMBER
            TURBO_TESTS
            TURBO_TESTS_DIR
            TURBO_TESTS_WORKER
            USE_MERGING
            VERBOSE
          ],
          path: "kettle/soup/cover/constants.rb"
        )
      end
    end
  end
end
