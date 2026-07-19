# Changelog

[![SemVer 2.0.0][📌semver-img]][📌semver] [![Keep-A-Changelog 1.0.0][📗keep-changelog-img]][📗keep-changelog]

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][📗keep-changelog],
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html),
and [yes][📌major-versions-not-sacred], platform and engine support are part of the [public API][📌semver-breaking].
Please file a bug if you notice a violation of semantic versioning.

[📌semver]: https://semver.org/spec/v2.0.0.html
[📌semver-img]: https://img.shields.io/badge/semver-2.0.0-FFDD67.svg?style=flat
[📌semver-breaking]: https://github.com/semver/semver/issues/716#issuecomment-869336139
[📌major-versions-not-sacred]: https://tom.preston-werner.com/2022/05/23/major-version-numbers-are-not-sacred.html
[📗keep-changelog]: https://keepachangelog.com/en/1.0.0/
[📗keep-changelog-img]: https://img.shields.io/badge/keep--a--changelog-1.0.0-FFDD67.svg?style=flat

## [Unreleased]

### Added

- Added `Kettle::Soup::Cover::Constants::WASHED_CONSTANTS` as the contract used
  by the spec harness to validate constant reload behavior.

### Changed

- `kettle-wash` is now a development dependency used by the test harness instead
  of a runtime dependency loaded during coverage bootstrap.

- kettle-jem-template-20260716-001 - Shim gemspec manifests now include
  `LICENSE.md` instead of nonexistent `LICENSE.txt`.
- kettle-jem-template-20260716-002 - Generated gemspec manifests now ship fewer
  repository-only files by default to reduce downstream distro packaging churn.

### Deprecated

### Removed

### Fixed

### Security

## [3.0.1] - 2026-07-18

- TAG: [v3.0.1][3.0.1t]
- COVERAGE: 100.00% -- 272/272 lines in 13 files
- BRANCH COVERAGE: 94.05% -- 79/84 branches in 13 files
- 15.58% documented

### Fixed

- turbo_tests2 workers now write SimpleCov reports under isolated
  `coverage/turbo_tests/<worker>` directories so only the parent collation step
  publishes root coverage reports such as `coverage/coverage.json`.
- turbo_tests2 workers now explicitly disable SimpleCov merge finalization so
  parent-owned collation remains the only final coverage report writer.
- turbo_tests2 rake hooks now restore coverage constants before setup or
  cleanup, preventing post-suite collation failures after specs reload constants.

## [3.0.0] - 2026-07-13

- TAG: [v3.0.0][3.0.0t]
- COVERAGE: 100.00% -- 258/258 lines in 13 files
- BRANCH COVERAGE: 98.57% -- 69/70 branches in 13 files
- 16.22% documented

### Changed

- `require "kettle/soup/cover"` no longer loads `version_gem` by default;
  require `kettle/soup/cover/version_gem` for the optional
  `VersionGem::Basic` extension.

## [3.0.0.rc6] - 2026-07-03

- TAG: [v3.0.0.rc6][3.0.0.rc6t]
- COVERAGE: 100.00% -- 257/257 lines in 12 files
- BRANCH COVERAGE: 98.57% -- 69/70 branches in 12 files
- 16.22% documented

### Fixed

- Package configured license files in gem release file lists.

## [3.0.0.rc5] - 2026-06-24

- TAG: [v3.0.0.rc5][3.0.0.rc5t]
- COVERAGE: 100.00% -- 257/257 lines in 12 files
- BRANCH COVERAGE: 100.00% -- 70/70 branches in 12 files
- 16.22% documented

### Changed

- Updated to latest kettle-jem template
  - Updated GHA SHA pins
  - Updated dependencies

## [3.0.0.rc4] - 2026-06-21

- TAG: [v3.0.0.rc4][3.0.0.rc4t]
- COVERAGE: 98.44% -- 253/257 lines in 12 files
- BRANCH COVERAGE: 95.71% -- 67/70 branches in 12 files
- 16.22% documented

### Removed

- Removed the `simplecov_json_formatter` dependency because SimpleCov v1
  includes `SimpleCov::Formatter::JSONFormatter`.

### Fixed

- Avoided redefining SimpleCov's built-in JSON formatter when coverage uses the
  JSON output format.

## [3.0.0.rc3] - 2026-06-21

- TAG: [v3.0.0.rc3][3.0.0.rc3t]
- COVERAGE: 98.44% -- 253/257 lines in 12 files
- BRANCH COVERAGE: 95.71% -- 67/70 branches in 12 files
- 16.22% documented

### Fixed

- Corrected OpenCollective funding metadata to use the `kettle-dev` collective.
- Aligned turbo_tests2 coverage workers with SimpleCov's shared resultset
  coordination by keeping worker resultsets under the canonical coverage root
  with unique worker command names, while preserving SimpleCov's final-worker
  formatter flow.

## [3.0.0.rc2] - 2026-06-20

- TAG: [v3.0.0.rc2][3.0.0.rc2t]
- COVERAGE: 100.00% -- 258/258 lines in 12 files
- BRANCH COVERAGE: 100.00% -- 72/72 branches in 12 files
- 16.44% documented

### Added

- Added support for JRuby 10.1 and TruffleRuby 34.0.

### Changed

- Retemplated project metadata and CI/development automation with `kettle-jem` v7.0.0.
- Updated SimpleCov configuration to use the v1 `cover`, `skip`, and `merging`
  APIs and to start coverage from the test helper instead of `.simplecov`.

### Fixed

- Fixed GitHub Actions release validation on `next` by allowing workflow push
  triggers to run on the release branch.

## [3.0.0.rc1] - 2026-06-19

- TAG: [v3.0.0.rc1][3.0.0.rc1t]
- COVERAGE: 100.00% -- 247/247 lines in 11 files
- BRANCH COVERAGE: 100.00% -- 68/68 branches in 11 files
- 16.44% documented

### Changed

- Upgrade to simplecov v1.0.pre
- Upgrade to simplecov-cobertura v4.0.pre
- Upgrade to version_gem v1.1.12
- latest kettle-jem template

### Fixed

- Fixed LCOV formatter loading to require the maintained
  `simplecov_lcov_formatter` dependency instead of the obsolete
  `simplecov-lcov` library name.

## [2.0.2] - 2026-06-09

- TAG: [v2.0.2][2.0.2t]
- COVERAGE: 100.00% -- 247/247 lines in 11 files
- BRANCH COVERAGE: 100.00% -- 68/68 branches in 11 files
- 16.44% documented

### Changed

- Retemplated development tooling for `kettle-dev` 2.2.3.

### Fixed

- Updated generated project metadata links to use the migrated `kettle-dev`
  GitHub organization.
- Restored `docs/CNAME` so the generated documentation site keeps its custom domain.

## [2.0.1] - 2026-06-02

- TAG: [v2.0.1][2.0.1t]
- COVERAGE: 100.00% -- 247/247 lines in 11 files
- BRANCH COVERAGE: 100.00% -- 68/68 branches in 11 files
- 16.44% documented

### Fixed

- Added `turbo_tests2:setup` and `turbo_tests2:cleanup` rake hook aliases so
  coverage setup and collation work when runners use either the legacy
  `turbo_tests` namespace or the current `turbo_tests2` namespace.
- Suppressed SimpleCov report formatter output inside `turbo_tests2` worker
  processes so only the parent collation process publishes coverage reports.

## [2.0.0] - 2026-06-02

- TAG: [v2.0.0][2.0.0t]
- COVERAGE: 100.00% -- 244/244 lines in 11 files
- BRANCH COVERAGE: 100.00% -- 70/70 branches in 11 files
- 16.67% documented

### Changed

- Raised direct runtime, development, style, and documentation dependency floors
  to their latest released compatible versions.
- Raised the minimum supported Ruby version from 2.7 to 3.2.

### Fixed

- Restored full CI coverage for the self-tested `coverage` rake task opener
  branches after re-templating.

## [1.1.3] - 2026-05-24

- TAG: [v1.1.3][1.1.3t]
- COVERAGE: 96.72% -- 236/244 lines in 11 files
- BRANCH COVERAGE: 85.71% -- 60/70 branches in 11 files
- 16.67% documented

### Fixed

- Removed duplicate-load warnings in the spec bootstrap while preserving coverage
  tracking for the library under test.
- Covered Ruby 4.0.5 / SimpleCov branch paths that were causing `bin/rake` to
  fail the configured coverage gate.
- Stabilized self-test coverage for rake task files so randomized spec order no
  longer changes the final branch coverage result.
- Removed the duplicate RuboCop Gradual run from the style workflow and fixed
  the generated style appraisal Gemfile for Ruby 4 extracted stdlibs.
- Removed the duplicate current workflow job caused by stale matrix axes.
- Marked generated workflow files as template-owned to prevent stale YAML keys
  from surviving future template runs.

- Isolated the spec-helper rake-task coverage exerciser under `tmp/` so
  turbo_tests2 workers cannot delete each other's real coverage artifacts before
  parent-process collation.
- `turbo_tests:cleanup` now publishes merged worker JSON coverage back to the
  canonical `coverage/coverage.json` path after collating worker resultsets, so
  CI uploaders and release tooling can continue to read standard coverage paths.
- Parsed `K_SOUP_COV_OPEN_BIN` with shellwords before opening the HTML report so
  opener commands with arguments report unavailable executables consistently
  across Ruby engines.

## [1.1.2] - 2026-05-23

- TAG: [v1.1.2][1.1.2t]
- COVERAGE: 96.06% -- 195/203 lines in 11 files
- BRANCH COVERAGE: 80.00% -- 40/50 branches in 11 files
- 18.46% documented

### Added

- `CLEAN_RESULTSET` / `K_SOUP_COV_CLEAN_RESULTSET`: deletes `coverage/.resultset.json`
  before SimpleCov starts to prevent stale entries from prior runs (e.g. after a refactor
  that shifts line/branch IDs) from producing phantom uncovered branches. Defaults to
  `false` on CI (each job already starts clean) and `true` locally (where developers
  re-run tests frequently). Override via `K_SOUP_COV_CLEAN_RESULTSET=true/false` or by
  setting the constant directly in Ruby. `Kettle::Soup::Cover.clean_resultset!` is also
  exposed as a public method for callers who want to trigger cleanup explicitly.
  **Note:** set `K_SOUP_COV_CLEAN_RESULTSET=false` inside `.simplecov_spawn.rb` so
  spawned subprocesses do not wipe the resultset being accumulated by the main process.
- Added `turbo_tests:setup` and `turbo_tests:cleanup` rake hooks for
  `turbo_tests2` coverage collection.
- Added `K_SOUP_COV_TURBO_TESTS` and `K_SOUP_COV_TURBO_TESTS_DIR` support so
  parallel workers write coverage under per-worker directories and the cleanup
  hook can collate the resultsets.

### Changed

- Updated documentation on hostile takeover of RubyGems
  - https://dev.to/galtzo/hostile-takeover-of-rubygems-my-thoughts-5hlo

### Fixed

- Deferred hard coverage minimum enforcement for `turbo_tests2` workers to the
  final collated coverage report, so individual workers with partial coverage do
  not fail before merged coverage is available.

## [1.1.1] - 2025-12-28

- TAG: [v1.1.1][1.1.1t]
- COVERAGE: 93.62% -- 132/141 lines in 10 files
- BRANCH COVERAGE: 50.00% -- 15/30 branches in 10 files
- 15.56% documented

### Added

- Added regression tests for `MIN_COVERAGE_HARD` behavior

### Fixed

- **BUGFIX**: `K_SOUP_COV_MIN_HARD=false` now correctly disables minimum coverage enforcement in CI
  - Previously, the condition `IS_CI || MIN_COVERAGE_HARD` meant minimum coverage was always enforced in CI
  - Now `MIN_COVERAGE_HARD` takes precedence: if explicitly set to `false`, minimum coverage is not enforced
  - The default behavior is unchanged: in CI without explicit setting, minimum coverage is still enforced

## [1.1.0] - 2025-12-28

- TAG: [v1.1.0][1.1.0t]
- COVERAGE: 93.62% -- 132/141 lines in 10 files
- BRANCH COVERAGE: 53.33% -- 16/30 branches in 10 files
- 15.56% documented

### Added

- When `ENV["MAX_ROWS"] == "0"`, explicitly, skip simplecov-console TTY output.
- Script `exe/kettle-soup-cover` generates coverage report
  - defaults to reading `$K_SOUP_COV_DIR/coverage.json`
  - prints a summarized report
  - accepts `-p/--path` or a positional path to coverage.json
  - requires the `json` formatter be configured in `$K_SOUP_COV_FORMATTERS` (or an explicit JSON path as above).

### Changed

- **Coverage merging is now enabled by default** - `USE_MERGING` defaults to `true`
  - Essential for projects that split tests into multiple rake tasks
  - Set `K_SOUP_COV_USE_MERGING=false` to disable
  - Aggregate coverage from multiple test runs (e.g., FFI specs, integration specs, unit specs) when uniquely named:
  - ```rake

    # Matrix checks will run in between FFI and MRI

    desc("Run Backend Matrix Specs")
    RSpec::Core::RakeTask.new(:backend_matrix_specs) do |t|
    t.pattern = "./spec_matrix/**/*_spec.rb"
    end
    desc("Set SimpleCov command name for backend matrix specs")
    task(:set_matrix_command_name) do
    ENV["K_SOUP_COV_COMMAND_NAME"] = "Backend Matrix Specs"
    end
    Rake::Task[:backend_matrix_specs].enhance([:set_matrix_command_name])
    ```
- **Merge timeout** - `MERGE_TIMEOUT` defaults to 3600 seconds (1 hour)
  - Sufficient for most test suites to complete all split tasks
  - Set `K_SOUP_COV_MERGE_TIMEOUT` to override

## [1.0.10] - 2025-07-15

- COVERAGE: 93.43% -- 128/137 lines in 10 files
- BRANCH COVERAGE: 50.00% -- 16/32 branches in 10 files
- 11.11% documented

### Added

- Add GitHub Pages site to badge info table
- YARD config, GFM compatible with relative file links
- Documentation site on GitHub Pages
  - [kettle-soup-cover.galtzo.com](https://kettle-soup-cover.galtzo.com)
- Auto-assign issues in the GitHub issue tracker

### Changed

- Updated `spec.homepage_uri` in gemspec to GitHub Pages YARD documentation site
- Updated contact email in gemspec to `floss@galtzo.com`
- Upgraded runtime dependency minimums:
  - simplecov-cobertura v3.0.0
  - simplecov-html v0.13.1
  - simplecov-rcov v0.3.7
  - simplecov-console v0.9.3
  - version_gem v1.1.8

## [1.0.9] - 2025-05-20

- COVERAGE: 93.43% -- 128/137 lines in 10 files
- BRANCH COVERAGE: 50.00% -- 16/32 branches in 10 files
- 11.11% documented

### Added

- YARD config, GFM compatible with relative file links
- Documentation site on GitHub Pages
  - [kettle-soup-cover.galtzo.com](https://kettle-soup-cover.galtzo.com)

### Changed

- Updated `spec.homepage_uri` in gemspec to GitHub Pages YARD documentation site

## [1.0.8] - 2025-05-20

- COVERAGE: 93.43% -- 128/137 lines in 10 files
- BRANCH COVERAGE: 50.00% -- 16/32 branches in 10 files
- 11.11% documented

### Added

- Link to discussions on GitHub

### Changed

- Fixed `spec.homepage` and `spec.source_code_uri` in gemspec

## [1.0.7] - 2025-05-20

- COVERAGE: 93.43% -- 128/137 lines in 10 files
- BRANCH COVERAGE: 50.00% -- 16/32 branches in 10 files
- 11.11% documented

### Added

- Document usage with minitest
- Document usage with https://github.com/irongut/CodeCoverageSummary
- Document usage with https://github.com/marocchino/sticky-pull-request-comment
- More documentation improvements
- Link to Discord

### Changed

 - Gem build: Don't check for cert if SKIP_GEM_SIGNING is set
   - Allows linux packaging systems to build gem without signing via rubygems
 - Update homepage in gemspec
 - Improved loading of version.rb in gemspec

## [1.0.6] - 2025-05-04

- COVERAGE: 93.43% -- 128/137 lines in 10 files
- BRANCH COVERAGE: 50.00% -- 16/32 branches in 10 files
- 11.11% documented

### Added

- Support for linux, and other OSes, in `coverage` rake task
  - previously was macOS only (would raise error on other OSes)
- ✨ `Kettle::Soup::Cover::OPEN_BIN`
  - Set `export K_SOUP_COV_OPEN_BIN=open` to use macOS' `open` command in `coverage` task
  - Set `export K_SOUP_COV_OPEN_BIN=xdg-open` to use Linux' `xdg-open` command in `coverage` task
  - Set `export K_SOUP_COV_OPEN_BIN=` to just print the path to the HTML coverage report in `coverage` task
- Test coverage increased from 55 => 93 for lines
- Test coverage increased from 25 => 50 for branches

### Changed

- Refactored internals in ways that should not affect public APIs
  - allows much greater test coverage
  - report a bug if anything breaks!
- Going forward all releases will be signed by my key that expires 2045-04-29

### Fixed

- require hooks such that both work equally well:
  - `require "kettle/soup/cover"`
  - `require "kettle-soup-cover"`
- Allow unsigned gem builds (for linux distros)
  - In the ENV set `SKIP_GEM_SIGNING` to any value

## [1.0.5] - 2025-04-03

### Added

- Documentation
- Support for malformed `K_SOUP_COV_FORMATTERS` (extra spaces)
- Code coverage tools QLTY, and CodeCov.io
- Added Ruby 3.3, 3.4 to CI

### Changed

- Update to Contributor Covenant 2.1
- Allow unsigned gem builds (for linux distros)
- Checksums are now created by `stone_checksums` gem

### Fixed

- Incorrect documentation of ENV variables that control gem behavior
- Prefer `Kernel.load` > `load` in gemspec
  - https://github.com/simplecov-ruby/simplecov/issues/557#issuecomment-2630782358

## [1.0.4] - 2024-06-11

### Added

- Documentation

### Changed

- `version_gem` requirement to 1.0.4

## [1.0.3] - 2024-05-23

### Added

- Documentation
- Mirror repo on GitHub: https://github.com/kettle-dev/kettle-soup-cover
- More tests

### Fixed

- Incorrect URLs for homepage, etc

## [1.0.2] - 2023-10-19

### Fixed

- Include new `coverage` rake task in the built gem
  - Goddamnit
- Try to get checksum for SHA-256 to match what is published on Rubygems.org

## [1.0.1] - 2023-10-19

### Fixed

- Include new `coverage` rake task in the built gem

## [1.0.0] - 2023-10-19

### Added

- ✨ `Regexp.escape` the `FILTER_DIRS` to allow for paths to be excluded from coverage
  - paths must always start at the root of the project, but no leading or trailing slash
- ✨ Rake task `coverage` will run spec suite, and open results in a browser.
- ✨ `Kettle::Soup::Cover::PREFIX` allows configuration of a custom ENV variable name prefix
  - Set `export K_SOUP_COV_DEBUG="K_SOUP_COV_"` (default shown)
- ✨ `Kettle::Soup::Cover::USE_MERGING`
  - Set `export K_SOUP_COV_USE_MERGING=true`
- ✨ `Kettle::Soup::Cover::MERGE_TIMEOUT`
  - Set `export K_SOUP_COV_MERGE_TIMEOUT=3600`
- ✨ `Kettle::Soup::Cover::DEBUG` - similar to `VERBOSE`, only moreso!
  - Set `export K_SOUP_COV_DEBUG=true`
  - NOTE: This gem actually has zero output statements.
    - The utility of `DEBUG` and `VERBOSE` being a part of this library is
      to normalize handling of this common logical need in other libraries.
- ✨ `Kettle::Soup::Cover.load_filters`
  - `Kettle::Soup::Cover::Filters::GtLineFilter`
  - `Kettle::Soup::Cover::Filters::LtLineFilter`
- More and better documentation

### Changed

- This gem no longer does `require "simplecov"`
  - Instead you can `require "simplecov" if Kettle::Soup::Cover::DO_COV` wherever you deem fit

### Fixed

- All ENV vars now begin with a uniform prefix for this gem:
  - `K_SOUP_COV_*`

## [0.1.0] - 2023-10-17

- Initial release

[Unreleased]: https://github.com/kettle-dev/kettle-soup-cover/compare/v3.0.1...HEAD
[3.0.1]: https://github.com/kettle-dev/kettle-soup-cover/compare/v3.0.0...v3.0.1
[3.0.1t]: https://github.com/kettle-dev/kettle-soup-cover/releases/tag/v3.0.1
[3.0.0]: https://github.com/kettle-dev/kettle-soup-cover/compare/v3.0.0.rc6...v3.0.0
[3.0.0t]: https://github.com/kettle-dev/kettle-soup-cover/releases/tag/v3.0.0
[3.0.0.rc6]: https://github.com/kettle-dev/kettle-soup-cover/compare/v3.0.0.rc5...v3.0.0.rc6
[3.0.0.rc6t]: https://github.com/kettle-dev/kettle-soup-cover/releases/tag/v3.0.0.rc6
[3.0.0.rc5]: https://github.com/kettle-dev/kettle-soup-cover/compare/v3.0.0.rc4...v3.0.0.rc5
[3.0.0.rc5t]: https://github.com/kettle-dev/kettle-soup-cover/releases/tag/v3.0.0.rc5
[3.0.0.rc4]: https://github.com/kettle-dev/kettle-soup-cover/compare/v3.0.0.rc3...v3.0.0.rc4
[3.0.0.rc4t]: https://github.com/kettle-dev/kettle-soup-cover/releases/tag/v3.0.0.rc4
[2.0.2]: https://github.com/kettle-dev/kettle-soup-cover/compare/v2.0.1...v2.0.2
[2.0.2t]: https://github.com/kettle-dev/kettle-soup-cover/releases/tag/v2.0.2
[2.0.1]: https://github.com/kettle-dev/kettle-soup-cover/compare/v2.0.0...v2.0.1
[2.0.1t]: https://github.com/kettle-dev/kettle-soup-cover/releases/tag/v2.0.1
[2.0.0]: https://github.com/kettle-dev/kettle-soup-cover/compare/v1.1.3...v2.0.0
[2.0.0t]: https://github.com/kettle-dev/kettle-soup-cover/releases/tag/v2.0.0
[1.1.3]: https://github.com/kettle-dev/kettle-soup-cover/compare/v1.1.2...v1.1.3
[1.1.3t]: https://github.com/kettle-dev/kettle-soup-cover/releases/tag/v1.1.3
[1.1.2]: https://github.com/kettle-dev/kettle-soup-cover/compare/v1.1.1...v1.1.2
[1.1.2t]: https://github.com/kettle-dev/kettle-soup-cover/releases/tag/v1.1.2
[1.1.1]: https://github.com/kettle-dev/kettle-soup-cover/compare/v1.1.0...v1.1.1
[1.1.1t]: https://github.com/kettle-dev/kettle-soup-cover/releases/tag/v1.1.1
[1.1.0]: https://github.com/kettle-dev/kettle-soup-cover/compare/v1.0.10...v1.1.0
[1.1.0t]: https://github.com/kettle-dev/kettle-soup-cover/releases/tag/v1.1.0
[1.0.10]: https://gitlab.com/kettle-dev/kettle-soup-cover/-/compare/v1.0.9...v1.0.10
[1.0.9]: https://gitlab.com/kettle-dev/kettle-soup-cover/-/compare/v1.0.8...v1.0.9
[1.0.8]: https://gitlab.com/kettle-dev/kettle-soup-cover/-/compare/v1.0.7...v1.0.8
[1.0.7]: https://gitlab.com/kettle-dev/kettle-soup-cover/-/compare/v1.0.6...v1.0.7
[1.0.6]: https://gitlab.com/kettle-dev/kettle-soup-cover/-/compare/v1.0.5...v1.0.6
[1.0.5]: https://gitlab.com/kettle-dev/kettle-soup-cover/-/compare/v1.0.4...v1.0.5
[1.0.4]: https://gitlab.com/kettle-dev/kettle-soup-cover/-/compare/v1.0.3...v1.0.4
[1.0.3]: https://gitlab.com/kettle-dev/kettle-soup-cover/-/compare/v1.0.2...v1.0.3
[1.0.2]: https://gitlab.com/kettle-dev/kettle-soup-cover/-/compare/v1.0.1...v1.0.2
[1.0.1]: https://gitlab.com/kettle-dev/kettle-soup-cover/-/compare/v1.0.0...v1.0.1
[1.0.0]: https://gitlab.com/kettle-dev/kettle-soup-cover/-/compare/v0.1.0...v1.0.0
[0.1.0]: https://github.com/kettle-dev/kettle-soup-cover/compare/97ddbbca309b87c7f6eed0137b08cad74ec81235...v0.1.0
