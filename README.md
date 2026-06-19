<a href="https://github.com/kettle-dev"><img alt="kettle-dev Logo by Aboling0, CC BY-SA 4.0" src="https://logos.galtzo.com/assets/images/kettle-dev/avatar-128px.svg" width="12%" align="right"/></a> <a href="https://github.com/kettle-dev/kettle-soup-cover"><img alt="kettle-soup-cover Logo by Aboling0, CC BY-SA 4.0" src="https://logos.galtzo.com/assets/images/kettle-dev/kettle-soup-cover/avatar-128px.svg" width="12%" align="right"/></a>

# 🥘 Kettle::Soup::Cover

[![Version][👽versioni]][👽version] [![GitHub tag (latest SemVer)][⛳️tag-img]][⛳️tag] [![License: AGPL-3.0-only][📄license-img]][📄license] [![Downloads Rank][👽dl-ranki]][👽dl-rank] [![CodeCov Test Coverage][🏀codecovi]][🏀codecov] [![Coveralls Test Coverage][🏀coveralls-img]][🏀coveralls] [![QLTY Test Coverage][🏀qlty-covi]][🏀qlty-cov] [![QLTY Maintainability][🏀qlty-mnti]][🏀qlty-mnt] [![CI Heads][🚎3-hd-wfi]][🚎3-hd-wf] [![CI Runtime Dependencies @ HEAD][🚎12-crh-wfi]][🚎12-crh-wf] [![CI Current][🚎11-c-wfi]][🚎11-c-wf] [![CI Truffle Ruby][🚎9-t-wfi]][🚎9-t-wf] [![CI JRuby][🚎10-j-wfi]][🚎10-j-wf] [![Deps Locked][🚎13-🔒️-wfi]][🚎13-🔒️-wf] [![Deps Unlocked][🚎14-🔓️-wfi]][🚎14-🔓️-wf] [![CI Test Coverage][🚎2-cov-wfi]][🚎2-cov-wf] [![CI Style][🚎5-st-wfi]][🚎5-st-wf]

`if ci_badges.map(&:color).detect { it != "green"}` ☝️ [let me know][✉️discord-invite], as I may have missed the [discord notification][✉️discord-invite].

---

`if ci_badges.map(&:color).all? { it == "green"}` 👇️ send money so I can do more of this. FLOSS maintenance is now my full-time job.

[![OpenCollective Backers][🖇osc-backers-i]][🖇osc-backers] [![OpenCollective Sponsors][🖇osc-sponsors-i]][🖇osc-sponsors] [![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor] [![Liberapay Goal Progress][⛳liberapay-img]][⛳liberapay] [![Donate on PayPal][🖇paypal-img]][🖇paypal] [![Buy me a coffee][🖇buyme-small-img]][🖇buyme] [![Donate on Polar][🖇polar-img]][🖇polar] [![Donate at ko-fi.com][🖇kofi-img]][🖇kofi]

<details markdown="1">
 <summary>👣 How will this project approach the September 2025 hostile takeover of RubyGems? 🚑️</summary>

I've summarized my thoughts in [this blog post](https://dev.to/galtzo/hostile-takeover-of-rubygems-my-thoughts-5hlo).

</details>

## 🌻 Synopsis <a href="https://discord.gg/3qme4XHNKN"><img alt="Galtzo FLOSS Logo by Aboling0, CC BY-SA 4.0" src="https://logos.galtzo.com/assets/images/galtzo-floss/avatar-128px.svg" width="8%" align="right"/></a> <a href="https://ruby-toolbox.com"><img alt="ruby-lang Logo, Yukihiro Matsumoto, Ruby Visual Identity Team, CC BY-SA 2.5" src="https://logos.galtzo.com/assets/images/ruby-lang/avatar-128px.svg" width="8%" align="right"/></a>

Four lines of code to get a configured, curated, opinionated, set of dependencies for Test Coverage, and that's *including* the two lines for `require "simplecov"`, and `SimpleCov.start`.

Configured for what?  To work out of the box on every CI*.  Batteries included.
For apps and libraries.  Any test framework.  Many code coverage related GitHub Actions (example configs [1](#marocchinosticky-pull-request-comment), [2](#irongutcodecoveragesummary)).

| Test Framework | Helper                      | Config                        |
|----------------|-----------------------------|-------------------------------|
| MiniTest       | [test helper][mini-helper]  | [.simplecov][mini-simplecov]  |
| RSpec          | [spec helper][rpsec-helper] | [.simplecov][rspec-simplecov] |

[mini-helper]: https://github.com/pboling/kettle-soup-cover/blob/master/tests/test_kettle-soup-cover.rb
[mini-simplecov]: https://github.com/pboling/kettle-soup-cover/blob/master/.simplecov
[rpsec-helper]: https://github.com/oauth-xx/oauth2/blob/main/spec/spec_helper.rb
[rspec-simplecov]: https://github.com/oauth-xx/oauth2/blob/main/.simplecov

### 📔 DO YOU LIKE PATTERNS?!? 📔

This library's local dev / testing / CI dependency structure serves as an example of a "modular gemfile" pattern
enabling a discrete gemfile for each CI workflow.

<details>
  <summary>What is a modular gemfile?</summary>

This modular pattern has the following benefits:

- All dependencies are DRY, never repeated.
- All modular gemfiles are shared between the main `Gemfile`, and the workflow `gemfiles/*.gemfile`s that need them.
- All gemfiles source from the `gemspec`.

If you like this idea, there is an even better alternative.

I've codified it for reuse in my [appraisal2](https://github.com/appraisal-rb/appraisal2/) gem,
which is a hard fork of the venerable `appraisal` gem due to that gem's lack of support for modular gemfiles.

</details>

📔 ME TOO! 📔

### 12-factor

One of the major benefits of using this library is not having to figure
out how to get multiple coverage output formats working.  I did that for you,
and I got all of them working, at the same time together, or al la carte. Kum-ba-ya.

A quick shot of 12-factor coverage power, straight to your brain:

```console
export K_SOUP_COV_COMMAND_NAME="RSpec (COVERAGE)" # Display name for the coverage run
export K_SOUP_COV_DEBUG=false # Enable debug output for configuration (true/false)
export K_SOUP_COV_DIR=coverage # Directory where coverage reports are written
export K_SOUP_COV_DO=true # Enable coverage collection (true/false)
export K_SOUP_COV_FILTER_DIRS="bin,docs,vendor" # Comma-separated dirs to filter out of coverage
export K_SOUP_COV_FORMATTERS="html,tty" # Comma-separated list: html,xml,rcov,lcov,json,tty
export K_SOUP_COV_MERGE_TIMEOUT=3600 # Timeout in seconds when merging multiple coverage results
export K_SOUP_COV_MIN_BRANCH=53 # Minimum required branch coverage percentage (integer)
export K_SOUP_COV_MIN_HARD=true # If true, fail the run when coverage thresholds are not met
export K_SOUP_COV_MIN_LINE=69 # Minimum required line coverage percentage (integer)
export K_SOUP_COV_MULTI_FORMATTERS=true # Enable multiple SimpleCov formatters (true/false)
export K_SOUP_COV_PREFIX="K_SOUP_COV_" # Prefix used for the envvars (useful for namespacing)
export K_SOUP_COV_OPEN_BIN=xdg-open # Command to open HTML report in `coverage` rake task (or empty to disable)
export K_SOUP_COV_USE_MERGING=false # Enable merging of results for parallel/test matrix runs (true/false)
export K_SOUP_COV_VERBOSE=false # Enable verbose logging (true/false)
export MAX_ROWS=5 # simplecov-console setting: limits tty output to the worst N rows of uncovered files
```

I hope I've piqued your interest enough to give it a ⭐️ if the forge you are on supports it.

<details>
  <summary>What does the name mean?</summary>

A Covered Kettle of SOUP (Software of Unknown Provenance)

The name is derived in part from the medical devices field,
where this library is considered a package of [SOUP](https://en.wikipedia.org/wiki/Software_of_unknown_pedigree).

</details>

## 💡 Info you can shake a stick at

| Tokens to Remember | [![Gem name][⛳️name-img]][⛳️gem-name] [![Gem namespace][⛳️namespace-img]][⛳️gem-namespace] |
|-------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Works with JRuby | [![JRuby 10.0 Compat][💎jruby-10.0i]][🚎jruby-10.0-wf] [![JRuby current Compat][💎jruby-c-i]][🚎10-j-wf] [![JRuby HEAD Compat][💎jruby-headi]][🚎3-hd-wf]|
| Works with Truffle Ruby | [![Truffle Ruby 24.2 Compat][💎truby-24.2i]][🚎truby-24.2-wf] [![Truffle Ruby 25.0 Compat][💎truby-25.0i]][🚎truby-25.0-wf] [![Truffle Ruby 33.0 Compat][💎truby-33.0i]][🚎truby-33.0-wf] [![Truffle Ruby current Compat][💎truby-c-i]][🚎9-t-wf] [![Truffle Ruby HEAD Compat][💎truby-headi]][🚎3-hd-wf]|
| Works with MRI Ruby 4 | [![Ruby current Compat][💎ruby-c-i]][🚎11-c-wf] [![Ruby HEAD Compat][💎ruby-headi]][🚎3-hd-wf]|
| Works with MRI Ruby 3 | [![Ruby 3.2 Compat][💎ruby-3.2i]][🚎ruby-3.2-wf] [![Ruby 3.3 Compat][💎ruby-3.3i]][🚎ruby-3.3-wf] [![Ruby 3.4 Compat][💎ruby-3.4i]][🚎ruby-3.4-wf]|
| Support & Community | [![Join Me on Daily.dev's RubyFriends][✉️ruby-friends-img]][✉️ruby-friends] [![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite] [![Get help from me on Upwork][👨🏼‍🏫expsup-upwork-img]][👨🏼‍🏫expsup-upwork] [![Get help from me on Codementor][👨🏼‍🏫expsup-codementor-img]][👨🏼‍🏫expsup-codementor] |
| Source | [![Source on GitLab.com][📜src-gl-img]][📜src-gl] [![Source on CodeBerg.org][📜src-cb-img]][📜src-cb] [![Source on Github.com][📜src-gh-img]][📜src-gh] [![The best SHA: dQw4w9WgXcQ!][🧮kloc-img]][🧮kloc] |
| Documentation | [![Current release on RubyDoc.info][📜docs-cr-rd-img]][🚎yard-current] [![YARD on Galtzo.com][📜docs-head-rd-img]][🚎yard-head] [![Maintainer Blog][🚂maint-blog-img]][🚂maint-blog] [![GitLab Wiki][📜gl-wiki-img]][📜gl-wiki] [![GitHub Wiki][📜gh-wiki-img]][📜gh-wiki] |
| Compliance | [![License: AGPL-3.0-only][📄license-img]][📄license] [![Apache license compatibility: Category X][📄license-compat-img]][📄license-compat] [![📄ilo-declaration-img]][📄ilo-declaration] [![Security Policy][🔐security-img]][🔐security] [![Contributor Covenant 2.1][🪇conduct-img]][🪇conduct] [![SemVer 2.0.0][📌semver-img]][📌semver] |
| Style | [![Enforced Code Style Linter][💎rlts-img]][💎rlts] [![Keep-A-Changelog 1.0.0][📗keep-changelog-img]][📗keep-changelog] [![Gitmoji Commits][📌gitmoji-img]][📌gitmoji] [![Compatibility appraised by: appraisal2][💎appraisal2-img]][💎appraisal2] |
| Maintainer 🎖️ | [![Follow Me on LinkedIn][💖🖇linkedin-img]][💖🖇linkedin] [![Follow Me on Ruby.Social][💖🐘ruby-mast-img]][💖🐘ruby-mast] [![Follow Me on Bluesky][💖🦋bluesky-img]][💖🦋bluesky] [![Contact Maintainer][🚂maint-contact-img]][🚂maint-contact] [![My technical writing][💖💁🏼‍♂️devto-img]][💖💁🏼‍♂️devto] |
| `...` 💖 | [![Find Me on WellFound:][💖✌️wellfound-img]][💖✌️wellfound] [![Find Me on CrunchBase][💖💲crunchbase-img]][💖💲crunchbase] [![My LinkTree][💖🌳linktree-img]][💖🌳linktree] [![More About Me][💖💁🏼‍♂️aboutme-img]][💖💁🏼‍♂️aboutme] [🧊][💖🧊berg] [🐙][💖🐙hub] [🛖][💖🛖hut] [🧪][💖🧪lab] |

### Compatibility

Compatible with MRI Ruby 3.2.0+, and concordant releases of JRuby, and TruffleRuby.
CI workflows and Appraisals are generated for MRI Ruby 3.2.0+.
This test floor is configured by `ruby.test_minimum` in `.kettle-jem.yml` and
may be higher than the gem's runtime compatibility floor when legacy Rubies are
not practical for the current toolchain.

<a href="https://github.com/kettle-dev"><img alt="kettle-dev Logo by Aboling0, CC BY-SA 4.0" src="https://logos.galtzo.com/assets/images/kettle-dev/avatar-128px.svg" width="14%" align="right"/></a>

The _amazing_ test matrix is powered by the kettle-dev stack.

<details markdown="1">
<summary>How kettle-dev manages complexity in tests</summary>

| Gem | Source | Role | Daily download rank |
|-----|--------|------|---------------------|
| [appraisal2](https://bestgems.org/gems/appraisal2) | [GitHub](https://github.com/appraisal-rb/appraisal2) | multi-dependency Appraisal matrix generation | [![Daily download rank for appraisal2](https://img.shields.io/gem/rd/appraisal2.svg?style=flat-square)](https://bestgems.org/gems/appraisal2) |
| [appraisal2-rubocop](https://bestgems.org/gems/appraisal2-rubocop) | [GitHub](https://github.com/appraisal-rb/appraisal2-rubocop) | RuboCop Appraisal generator integration | [![Daily download rank for appraisal2-rubocop](https://img.shields.io/gem/rd/appraisal2-rubocop.svg?style=flat-square)](https://bestgems.org/gems/appraisal2-rubocop) |
| [kettle-dev](https://bestgems.org/gems/kettle-dev) | [GitHub](https://github.com/kettle-dev/kettle-dev) | development, release, and CI workflow tooling | [![Daily download rank for kettle-dev](https://img.shields.io/gem/rd/kettle-dev.svg?style=flat-square)](https://bestgems.org/gems/kettle-dev) |
| [kettle-jem](https://bestgems.org/gems/kettle-jem) | [GitHub](https://github.com/kettle-dev/kettle-jem) | Appraisals & CI workflow templates | [![Daily download rank for kettle-jem](https://img.shields.io/gem/rd/kettle-jem.svg?style=flat-square)](https://bestgems.org/gems/kettle-jem) |
| [kettle-test](https://bestgems.org/gems/kettle-test) | [GitHub](https://github.com/kettle-dev/kettle-test) | standard test runner and coverage harness | [![Daily download rank for kettle-test](https://img.shields.io/gem/rd/kettle-test.svg?style=flat-square)](https://bestgems.org/gems/kettle-test) |
| [rubocop-lts](https://bestgems.org/gems/rubocop-lts) | [GitHub](https://github.com/rubocop-lts/rubocop-lts) | Ruby-version-aware linting | [![Daily download rank for rubocop-lts](https://img.shields.io/gem/rd/rubocop-lts.svg?style=flat-square)](https://bestgems.org/gems/rubocop-lts) |
| [turbo_tests2](https://bestgems.org/gems/turbo_tests2) | [GitHub](https://github.com/galtzo-floss/turbo_tests2) | parallel test execution | [![Daily download rank for turbo_tests2](https://img.shields.io/gem/rd/turbo_tests2.svg?style=flat-square)](https://bestgems.org/gems/turbo_tests2) |

</details>

### Federated DVCS

<details markdown="1">
 <summary>Find this repo on federated forges (Coming soon!)</summary>

| Federated [DVCS][💎d-in-dvcs] Repository | Status | Issues | PRs | Wiki | CI | Discussions |
|-------------------------------------------------|-----------------------------------------------------------------------|---------------------------|--------------------------|---------------------------|--------------------------|------------------------------|
| 🧪 [kettle-dev/kettle-soup-cover on GitLab][📜src-gl] | The Truth | [💚][🤝gl-issues] | [💚][🤝gl-pulls] | [💚][📜gl-wiki] | 🐭 Tiny Matrix | ➖ |
| 🧊 [kettle-dev/kettle-soup-cover on CodeBerg][📜src-cb] | An Ethical Mirror ([Donate][🤝cb-donate]) | [💚][🤝cb-issues] | [💚][🤝cb-pulls] | ➖ | ⭕️ No Matrix | ➖ |
| 🐙 [kettle-dev/kettle-soup-cover on GitHub][📜src-gh] | Another Mirror | [💚][🤝gh-issues] | [💚][🤝gh-pulls] | [💚][📜gh-wiki] | 💯 Full Matrix | [💚][gh-discussions] |
| 🎮️ [Discord Server][✉️discord-invite] | [![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite] | [Let's][✉️discord-invite] | [talk][✉️discord-invite] | [about][✉️discord-invite] | [this][✉️discord-invite] | [library!][✉️discord-invite] |

</details>

[gh-discussions]: https://github.com/kettle-dev/kettle-soup-cover/discussions

### Enterprise Support [![Tidelift](https://tidelift.com/badges/package/rubygems/kettle-soup-cover)](https://tidelift.com/subscription/pkg/rubygems-kettle-soup-cover?utm_source=rubygems-kettle-soup-cover&utm_medium=referral&utm_campaign=readme)

Available as part of the Tidelift Subscription.

<details markdown="1">
 <summary>Need enterprise-level guarantees?</summary>

The maintainers of this and thousands of other packages are working with Tidelift to deliver commercial support and maintenance for the open source packages you use to build your applications. Save time, reduce risk, and improve code health, while paying the maintainers of the exact packages you use.

[![Get help from me on Tidelift][🏙️entsup-tidelift-img]][🏙️entsup-tidelift]

- 💡Subscribe for support guarantees covering _all_ your FLOSS dependencies
- 💡Tidelift is part of [Sonar][🏙️entsup-tidelift-sonar]
- 💡Tidelift pays maintainers to maintain the software you depend on!<br/>📊`@`Pointy Haired Boss: An [enterprise support][🏙️entsup-tidelift] subscription is "[never gonna let you down][🧮kloc]", and *supports* open source maintainers

Alternatively:

- [![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite]
- [![Get help from me on Upwork][👨🏼‍🏫expsup-upwork-img]][👨🏼‍🏫expsup-upwork]
- [![Get help from me on Codementor][👨🏼‍🏫expsup-codementor-img]][👨🏼‍🏫expsup-codementor]

</details>

## ✨ Installation

Install the gem and add to the application's Gemfile by executing:

```console
bundle add kettle-soup-cover
```

If bundler is not being used to manage dependencies, install the gem by executing:

```console
gem install kettle-soup-cover
```

## ⚙️ Configuration

### Merging

Below is some part of the Rakefile pulled from the [tree_haver](https://github.com/kettle-rb/tree_haver) gem which merges the results of various discrete RSpec test suites that are impossible to run at the same time. The pattern should also work for minitest / test unit.

```ruby
### SPEC TASKS
# Run FFI specs first (before the collision of MRI+FFI backends pollutes the environment),
# then run remaining specs. This ensures FFI tests get a clean environment
# while still validating that BackendConflict protection works.
#
# For coverage aggregation with SimpleCov merging:
# - Each task uses a unique K_SOUP_COV_COMMAND_NAME so SimpleCov tracks them separately
# - K_SOUP_COV_USE_MERGING=true must be set in .envrc for results to merge
# - K_SOUP_COV_MERGE_TIMEOUT should be set long enough for all tasks to complete
begin
  require "rspec/core/rake_task"

  # FFI specs run first in a clean environment
  desc("Run FFI backend specs first (before MRI loads)")
  RSpec::Core::RakeTask.new(:ffi_specs) do |t|
    t.pattern = "./spec/**/*_spec.rb"
    t.rspec_opts = "--tag ffi"
  end
  # Set unique command name at execution time for SimpleCov merging
  desc("Set SimpleCov command name for FFI specs")
  task(:set_ffi_command_name) do
    ENV["K_SOUP_COV_COMMAND_NAME"] = "FFI Specs"
  end
  Rake::Task[:ffi_specs].enhance([:set_ffi_command_name])

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

  # All other specs run after FFI specs
  desc("Run non-FFI specs (after FFI specs have run)")
  RSpec::Core::RakeTask.new(:remaining_specs) do |t|
    t.pattern = "./spec/**/*_spec.rb"
    t.rspec_opts = "--tag ~ffi"
  end
  desc("Set SimpleCov command name for remaining specs")
  task(:set_remaining_command_name) do
    ENV["K_SOUP_COV_COMMAND_NAME"] = "Remaining Specs"
  end
  Rake::Task[:remaining_specs].enhance([:set_remaining_command_name])

  # Final task to run all specs (for spec task, runs in single process for final coverage merge)
  desc("Run all specs in one process (no FFI isolation)")
  RSpec::Core::RakeTask.new(:all_specs) do |t|
    t.pattern = "spec/**{,/*/**}/*_spec.rb"
  end
  desc("Set SimpleCov command name for all specs")
  task(:set_all_command_name) do
    ENV["K_SOUP_COV_COMMAND_NAME"] = "All Specs"
  end
  Rake::Task[:all_specs].enhance([:set_all_command_name])

  # Override the default spec task to run in sequence
  # NOTE: We do NOT include :all_specs here because ffi_specs + remaining_specs already
  # cover all specs. Including all_specs would cause duplicated test runs.
  Rake::Task[:spec].clear if Rake::Task.task_defined?(:spec)
  desc("Run specs with FFI tests first, then backend matrix, then remaining tests")
  task(spec: [:ffi_specs, :backend_matrix_specs, :remaining_specs]) # rubocop:disable Rake/DuplicateTask
rescue LoadError
  desc("(stub) spec is unavailable")
  task(:spec) do # rubocop:disable Rake/DuplicateTask
    warn("NOTE: rspec isn't installed, or is disabled for #{RUBY_VERSION} in the current environment")
  end
end
```

## 🔧 Basic Usage

### RSpec or MiniTest

In your `spec/spec_helper.rb` or `tests/test_helper.rb`, just before loading the library under test,
add two lines of code:

### With Ruby 3.2+

```ruby
require "kettle-soup-cover"
require "simplecov" if Kettle::Soup::Cover::DO_COV # `.simplecov` is run here!
# IMPORTANT: If you are using MiniTest instead of RSpec, also do this (and not in .simplecov):
# SimpleCov.external_at_exit = true
```

#### Example: Rails & RSpec

In your `spec/rails_helper.rb`

```ruby
# External gems
require "kettle-soup-cover"

# This file is copied to spec/ when you run 'rails generate rspec:install'
# We provide a preconfigured version compatible with Rails 8
require "spec_helper"
ENV["RAILS_ENV"] ||= "test"

# Last thing before loading the app-under-test is code coverage.
require "simplecov" if Kettle::Soup::Cover::DO_COV # `.simplecov` is run here!
require File.expand_path("../config/environment", __dir__)
```

P.S. Ensure that you have `require: false` on the gem in the Gemfile,
and that it is in both `:development` and `:test` groups, since it ships a `coverage` rake task:

```ruby
group :development, :test do
  gem "kettle-soup-cover", "~> 1.0", ">= 1.0.10", require: false
end
```

### Projects that run tests against older Ruby versions, e.g. with Appraisals

```ruby
# NOTE: Gemfiles for older rubies won't have kettle-soup-cover.
#       The rescue LoadError handles that scenario.
begin
  require "kettle-soup-cover"

  if Kettle::Soup::Cover::DO_COV
    require "simplecov" # `.simplecov` is run here!

    # IMPORTANT: If you are using MiniTest instead of RSpec, also do this (and not in .simplecov):
    # SimpleCov.external_at_exit = true
  end
rescue LoadError => error
  # check the error message, if you are so inclined, and re-raise if not what is expected
  raise error unless error.message.include?("kettle")
end
```

### All projects

In your `.simplecov` file, add 2 lines of code:

```ruby
require "kettle/soup/cover/config" # 12-factor, ENV-based configuration, with good defaults!
# you could do this somewhere else, up to you, but you do have to do it somewhere
SimpleCov.start
```

See [Advanced Usage](#advanced-usage) below for more info,
but the simplest thing is to run all the coverage things,
which is configured by default on CI.  To replicate that locally you could:

```console
CI=true bundle exec rake test # or whatever command you run for tests.
```

To inspect the current local coverage report, use the bundled analyzer:

```console
bin/kettle-soup-cover -d
```

By default it clears the configured coverage directory, runs `bin/rake coverage`
with fresh JSON-only output, and then prints the detailed report.
If you want to inspect an already-generated artifact without rerunning tests,
pass it explicitly:

```console
bin/kettle-soup-cover -p coverage/coverage.json
```

That's it!

### Rakefile

You'll need to have your `test` task defined.
If you use `spec` instead, you can make it a pre-requisite of the `test` task with:

```ruby
desc "run spec task with test task"
task test: :spec
```

This gem provides a `coverage` task.
It runs the `test` task (see just above about that),
and opens the coverage results in a browser.

```ruby
require "kettle-soup-cover"
Kettle::Soup::Cover.install_tasks
```

### kettle-soup-cover (exe/kettle-soup-cover)

This gem ships a small helper binary `kettle-soup-cover` under `exe/kettle-soup-cover`. It consumes a SimpleCov JSON output (coverage/coverage.json) and prints a readable, summarized report of lines and branches. The script will, by default, look for `coverage/coverage.json` in the directory configured by `K_SOUP_COV_DIR` (defaults to `coverage`).

Usage examples:

```
kettle-soup-cover              # Uses $K_SOUP_COV_DIR/coverage.json (default coverage/coverage.json)
kettle-soup-cover -p path/to/coverage.json  # Read JSON from a custom path
kettle-soup-cover ./coverage/coverage.json  # Positional path is accepted as an alternative to -p/--path
kettle-soup-cover -f kettle/soup           # Show only files matching kettle/soup (partial substring match)
kettle-soup-cover -f "kettle/soup/**/*.rb" # Globbing is supported; -f will treat patterns containing *?[] as globs
```

Notes:

- The script requires the `json` formatter to be active in `K_SOUP_COV_FORMATTERS` if you don't supply an explicit JSON path via `-p` or a positional arg; otherwise it will abort with an actionable message.
- `-f/--file` is a *file filter* (partial path match) and cannot be used to specify the coverage JSON path.
- `K_SOUP_COV_DIR` controls the default path used by the script (defaults to `coverage`).

### Filters

There are two built-in SimpleCov filters which can be loaded via `Kettle::Soup::Cover.load_filters`.

You could use them like this:

```ruby
SimpleCov.add_group("Too Long", Kettle::Soup::Cover::Filters::GtLineFilter.new(1000))
```

### Advanced Usage

There are a number of ENV variables that control things within this gem.
All of them can be found, along with their default values, in [lib/kettle/soup/cover.rb][env-constants].

#### Handy List of ENV Variables

Most are self explanatory.
I tried to follow POLS, the principle of least surprise, so they mostly _DWTFYT_.
Want to help improve this documentation? PRs are easy!

Below is a reference for the environment variables used by this gem. Each section documents the variable name, its default value, what it controls, and an example of usage. Variable names are prefixed with the value of `K_SOUP_COV_PREFIX` (by default `K_SOUP_COV_`).

#### K_SOUP_COV_COMMAND_NAME

- Default: `RSpec (COVERAGE)`
- What it controls: Display name for the coverage run, used in UIs or log output.
- Example: `export K_SOUP_COV_COMMAND_NAME="Unit Tests (Coverage)"`

#### K_SOUP_COV_DEBUG

- Default: `false` (string value read truthily)
- What it controls: Enable debug output for the configuration, prints the prefixes and selected values.
- Example: `export K_SOUP_COV_DEBUG=true`

#### K_SOUP_COV_DIR

- Default: `coverage`
- What it controls: Directory where SimpleCov writes coverage reports. The `exe/kettle-soup-cover` script and rake tasks will look here for artefacts like `coverage.json` or `index.html`.
- Example: `export K_SOUP_COV_DIR=my-coverage`

#### K_SOUP_COV_DO

- Default: Uses `CI` if unset (`CI=false` default). Setting to `true` or `false` enables/disables coverage collection.
- What it controls: Controls whether the gem enables SimpleCov at runtime (`DO_COV` behavior).
- Example: `export K_SOUP_COV_DO=true`

#### K_SOUP_COV_FILTER_DIRS

- Default: `bin,certs,checksums,config,coverage,docs,features,gemfiles,pkg,results,sig,spec,src,test,test-results,vendor`
- What it controls: A comma-separated list of directory names to filter out from coverage reports.
- Example: `export K_SOUP_COV_FILTER_DIRS=vendor,bin,docs`

#### K_SOUP_COV_FORMATTERS

- Default: `html,xml,rcov,lcov,json,tty` on CI; `html,tty` locally.
- What it controls: Comma-separated list of formatters that determine the kind of coverage reports generated. Supported values include `html`, `xml`, `rcov`, `lcov`, `json`, `tty`.
- Example: `export K_SOUP_COV_FORMATTERS="html,json"`

Note: the `exe/kettle-soup-cover` script requires that the `json` formatter be enabled so it can read a canonical `coverage/coverage.json` file. If you plan to use that script, ensure `json` is included in your `K_SOUP_COV_FORMATTERS` value as shown in the example above.

#### K_SOUP_COV_CLEAN_RESULTSET

- Default: `false` on CI; `true` locally.
- What it controls: When true, deletes `coverage/.resultset.json` before SimpleCov starts. This prevents stale entries from prior runs (e.g., after a refactor that shifts line/branch numbers) from polluting the current run's coverage report. In CI each job starts from a clean workspace so this is unnecessary; locally developers re-run tests frequently and stale entries accumulate.
- Example: `export K_SOUP_COV_CLEAN_RESULTSET=false`

**Important for spawned-process coverage:** if you use `.simplecov_spawn.rb` (or similar) to collect coverage from child processes, set `K_SOUP_COV_CLEAN_RESULTSET=false` inside that file so spawned processes do not wipe the resultset that other workers are accumulating. Only the main process should clean.

#### K_SOUP_COV_MERGE_TIMEOUT

- Default: `nil`
- What it controls: When using merging (`K_SOUP_COV_USE_MERGING=true`), this sets a numeric timeout in seconds for the merge operation.
- Example: `export K_SOUP_COV_MERGE_TIMEOUT=3600`

#### K_SOUP_COV_MIN_BRANCH

- Default: `80`
- What it controls: Minimum allowed branch coverage percentage. Used to assert that coverage thresholds are met.
- Example: `export K_SOUP_COV_MIN_BRANCH=85`

#### K_SOUP_COV_MIN_HARD

- Default: Uses `CI` if unset (`CI=false` default). When true the build will fail if thresholds are not met.
- What it controls: Whether failing coverage thresholds should fail the run (hard failure) or only warn.
- Example: `export K_SOUP_COV_MIN_HARD=true`

#### K_SOUP_COV_MIN_LINE

- Default: `80`
- What it controls: Minimum allowed line coverage percentage.
- Example: `export K_SOUP_COV_MIN_LINE=92`

#### K_SOUP_COV_MULTI_FORMATTERS

- Default: If running on CI (true) the default is `true`, otherwise the default is true if any formatters are present.
- What it controls: Whether to configure SimpleCov to run multiple formatters concurrently or not.
- Example: `export K_SOUP_COV_MULTI_FORMATTERS=false`

#### K_SOUP_COV_PREFIX

- Default: `K_SOUP_COV_`
- What it controls: Prefix used for the environment variables described in this section; useful if you want a custom-namespaced set for tests.
- Example: `export K_SOUP_COV_PREFIX="MY_COV_"`

#### K_SOUP_COV_OPEN_BIN

- Default: Uses `open` on macOS and `xdg-open` on Linux.
- What it controls: Command used by the Rake `coverage` task to open the HTML report. Set to an empty value to disable auto-opening and just print report locations.
- Example: `export K_SOUP_COV_OPEN_BIN=xdg-open` or `export K_SOUP_COV_OPEN_BIN=` (to only print the path)

#### K_SOUP_COV_USE_MERGING

- Default: `nil` (disabled)
- What it controls: When true, enables result merging semantics for multiple test runs (works with merge timeout and other behaviors).
- Example: `export K_SOUP_COV_USE_MERGING=true`

#### K_SOUP_COV_VERBOSE

- Default: `false`
- What it controls: Enables additional verbose logging where supported within tasks and scripts.
- Example: `export K_SOUP_COV_VERBOSE=true`

Note: Some third-party formatters may also read their own environment variables. For example, the simplecov-console formatter supports `MAX_ROWS` to limit the tty output. This is not prefixed with `K_SOUP_COV_` by design and is passed through to the formatter directly.

Additionally, some of the included gems, like [`simplecov-console`][simplecov-console],
have their own complete suite of ENV variables you can configure.

[env-constants]: /lib/kettle/soup/cover.rb
[simplecov-console]: https://github.com/chetan/simplecov-console#options

#### Compatible with GitHub Actions for Code Coverage feedback in pull requests

If you don't want to configure a SaaS service to update your pull requests with
code coverage there are alternatives.

After the step that runs your test suite use one or more of the following.

##### irongut/CodeCoverageSummary

Repo: [irongut/CodeCoverageSummary][GHA-ccs-repo]

[GHA-ccs-repo]: https://github.com/irongut/CodeCoverageSummary

```yaml

      - name: Code Coverage Summary Report
        uses: irongut/CodeCoverageSummary@v1.3.0
        if: ${{ github.event_name == 'pull_request' }}
        with:
          filename: ./coverage/coverage.xml
          badge: true
          fail_below_min: true
          format: markdown
          hide_branch_rate: false
          hide_complexity: true
          indicators: true
          output: both
          thresholds: '100 100' # '<MIN LINE COVERAGE> <MIN BRANCH COVERAGE>'
        continue-on-error: ${{ matrix.experimental != 'false' }}
```

##### *marocchino/sticky-pull-request-comment*

Repo: [marocchino/sticky-pull-request-comment][GHA-sprc-repo]

[GHA-sprc-repo]: https://github.com/marocchino/sticky-pull-request-comment

```yaml
      - name: Add Coverage PR Comment
        uses: marocchino/sticky-pull-request-comment@v2
        if: ${{ github.event_name == 'pull_request' }}
        with:
          recreate: true
          path: code-coverage-results.md
        continue-on-error: ${{ matrix.experimental != 'false' }}
```

## 🔐 Security

See [SECURITY.md][🔐security].

## 🤝 Contributing

If you need some ideas of where to help, you could work on adding more code coverage,
or if it is already 💯 (see [below](#code-coverage)) check [issues][🤝gh-issues] or [PRs][🤝gh-pulls],
or use the gem and think about how it could be better.

We [![Keep A Changelog][📗keep-changelog-img]][📗keep-changelog] so if you make changes, remember to update it.

See [CONTRIBUTING.md][🤝contributing] for more detailed instructions.

### 🚀 Release Instructions

See [CONTRIBUTING.md][🤝contributing].

### Code Coverage

<details markdown="1">
<summary>Coverage service badges</summary>

[![Coverage Graph][🏀codecov-g]][🏀codecov]

[![Coveralls Test Coverage][🏀coveralls-img]][🏀coveralls]

[![QLTY Test Coverage][🏀qlty-covi]][🏀qlty-cov]

</details>

### 🪇 Code of Conduct

Everyone interacting with this project's codebases, issue trackers,
chat rooms and mailing lists agrees to follow the [![Contributor Covenant 2.1][🪇conduct-img]][🪇conduct].

## 🌈 Contributors

[![Contributors][🖐contributors-img]][🖐contributors]

Made with [contributors-img][🖐contrib-rocks].

Also see GitLab Contributors: [https://gitlab.com/kettle-dev/kettle-soup-cover/-/graphs/main][🚎contributors-gl]

<details markdown="1">
 <summary>⭐️ Star History</summary>

<a href="https://star-history.com/kettle-dev/kettle-soup-cover&Date">
 <picture>
 <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=kettle-dev/kettle-soup-cover&type=Date&theme=dark" />
 <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=kettle-dev/kettle-soup-cover&type=Date" />
 <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=kettle-dev/kettle-soup-cover&type=Date" />
 </picture>
</a>

</details>

## 📌 Versioning

This library follows [![Semantic Versioning 2.0.0][📌semver-img]][📌semver] for its public API where practical.
For most applications, prefer the [Pessimistic Version Constraint][📌pvc] with two digits of precision.

For example:

```ruby
spec.add_dependency("kettle-soup-cover", "~> 3.0")
```

<details markdown="1">
<summary>📌 Is "Platform Support" part of the public API? More details inside.</summary>

Dropping support for a platform can be a breaking change for affected users.
If a release changes supported platforms, it should be called out clearly in the changelog and versioned with that impact in mind.

To get a better understanding of how SemVer is intended to work over a project's lifetime,
read this article from the creator of SemVer:

- ["Major Version Numbers are Not Sacred"][📌major-versions-not-sacred]

</details>

See [CHANGELOG.md][📌changelog] for a list of releases.

## 📄 License

The gem is available under the following license: [AGPL-3.0-only](AGPL-3.0-only.md).
See [LICENSE.md][📄license] for details.

If none of the available licenses suit your use case, please [contact us](mailto:floss@galtzo.com) to discuss a custom commercial license.

### © Copyright

See [LICENSE.md][📄license] for the official copyright notice.

<details markdown="1">
<summary>Copyright holders</summary>

- Copyright (c) 2023-2026 Peter H. Boling

</details>

## 🤑 A request for help

Maintainers have teeth and need to pay their dentists.
After getting laid off in an RIF in March, and encountering difficulty finding a new one,
I began spending most of my time building open source tools.
I'm hoping to be able to pay for my kids' health insurance this month,
so if you value the work I am doing, I need your support.
Please consider sponsoring me or the project.

To join the community or get help 👇️ Join the Discord.

[![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite]

To say "thanks!" ☝️ Join the Discord or 👇️ send money.

[![Sponsor kettle-dev/kettle-soup-cover on Open Source Collective][🖇osc-all-bottom-img]][🖇osc] 💌 [![Sponsor me on GitHub Sponsors][🖇sponsor-bottom-img]][🖇sponsor] 💌 [![Sponsor me on Liberapay][⛳liberapay-bottom-img]][⛳liberapay] 💌 [![Donate on PayPal][🖇paypal-bottom-img]][🖇paypal]

### Please give the project a star ⭐ ♥.

Many parts of this project are actively managed by a [kettle-jem](https://github.com/structuredmerge/structuredmerge-ruby/tree/main/gems/kettle-jem) smart template utilizing [StructuredMerge.org](https://structuredmerge.org) merge contracts.

Thanks for RTFM. ☺️

[⛳liberapay-img]: https://img.shields.io/liberapay/goal/pboling.svg?logo=liberapay&color=a51611&style=flat
[⛳liberapay-bottom-img]: https://img.shields.io/liberapay/goal/pboling.svg?style=for-the-badge&logo=liberapay&color=a51611
[⛳liberapay]: https://liberapay.com/pboling/donate
[🖇osc-all-img]: https://img.shields.io/opencollective/all/kettle-dev
[🖇osc-sponsors-img]: https://img.shields.io/opencollective/sponsors/kettle-dev
[🖇osc-backers-img]: https://img.shields.io/opencollective/backers/kettle-dev
[🖇osc-backers]: https://opencollective.com/kettle-dev#backer
[🖇osc-backers-i]: https://opencollective.com/kettle-dev/backers/badge.svg?style=flat
[🖇osc-sponsors]: https://opencollective.com/kettle-dev#sponsor
[🖇osc-sponsors-i]: https://opencollective.com/kettle-dev/sponsors/badge.svg?style=flat
[🖇osc-all-bottom-img]: https://img.shields.io/opencollective/all/kettle-dev?style=for-the-badge
[🖇osc-sponsors-bottom-img]: https://img.shields.io/opencollective/sponsors/kettle-dev?style=for-the-badge
[🖇osc-backers-bottom-img]: https://img.shields.io/opencollective/backers/kettle-dev?style=for-the-badge
[🖇osc]: https://opencollective.com/kettle-dev
[🖇sponsor-img]: https://img.shields.io/badge/Sponsor_Me!-pboling.svg?style=social&logo=github
[🖇sponsor-bottom-img]: https://img.shields.io/badge/Sponsor_Me!-pboling-blue?style=for-the-badge&logo=github
[🖇sponsor]: https://github.com/sponsors/pboling
[🖇polar-img]: https://img.shields.io/badge/polar-donate-a51611.svg?style=flat
[🖇polar]: https://polar.sh/pboling
[🖇kofi-img]: https://img.shields.io/badge/ko--fi-%E2%9C%93-a51611.svg?style=flat
[🖇kofi]: https://ko-fi.com/pboling
[🖇patreon-img]: https://img.shields.io/badge/patreon-donate-a51611.svg?style=flat
[🖇patreon]: https://patreon.com/galtzo
[🖇buyme-small-img]: https://img.shields.io/badge/buy_me_a_coffee-%E2%9C%93-a51611.svg?style=flat
[🖇buyme-img]: https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20latte&emoji=&slug=pboling&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff
[🖇buyme]: https://www.buymeacoffee.com/pboling
[🖇paypal-img]: https://img.shields.io/badge/donate-paypal-a51611.svg?style=flat&logo=paypal
[🖇paypal-bottom-img]: https://img.shields.io/badge/donate-paypal-a51611.svg?style=for-the-badge&logo=paypal&color=0A0A0A
[🖇paypal]: https://www.paypal.com/paypalme/peterboling
[🖇floss-funding.dev]: https://floss-funding.dev
[🖇floss-funding-gem]: https://github.com/galtzo-floss/floss_funding
[✉️discord-invite]: https://discord.gg/3qme4XHNKN
[✉️discord-invite-img-ftb]: https://img.shields.io/discord/1373797679469170758?style=for-the-badge&logo=discord
[✉️ruby-friends-img]: https://img.shields.io/badge/daily.dev-%F0%9F%92%8E_Ruby_Friends-0A0A0A?style=for-the-badge&logo=dailydotdev&logoColor=white
[✉️ruby-friends]: https://app.daily.dev/squads/rubyfriends

[✇bundle-group-pattern]: https://gist.github.com/pboling/4564780
[⛳️gem-namespace]: https://github.com/kettle-dev/kettle-soup-cover
[⛳️namespace-img]: https://img.shields.io/badge/namespace-Kettle::Soup::Cover-3C2D2D.svg?style=square&logo=ruby&logoColor=white
[⛳️gem-name]: https://bestgems.org/gems/kettle-soup-cover
[⛳️name-img]: https://img.shields.io/badge/name-kettle--soup--cover-3C2D2D.svg?style=square&logo=rubygems&logoColor=red
[⛳️tag-img]: https://img.shields.io/github/tag/kettle-dev/kettle-soup-cover.svg
[⛳️tag]: https://github.com/kettle-dev/kettle-soup-cover/releases
[🚂maint-blog]: http://www.railsbling.com/tags/kettle-soup-cover
[🚂maint-blog-img]: https://img.shields.io/badge/blog-railsbling-0093D0.svg?style=for-the-badge&logo=rubyonrails&logoColor=orange
[🚂maint-contact]: http://www.railsbling.com/contact
[🚂maint-contact-img]: https://img.shields.io/badge/Contact-Maintainer-0093D0.svg?style=flat&logo=rubyonrails&logoColor=red
[💖🖇linkedin]: http://www.linkedin.com/in/peterboling
[💖🖇linkedin-img]: https://img.shields.io/badge/LinkedIn-Profile-0B66C2?style=flat&logo=newjapanprowrestling
[💖✌️wellfound]: https://wellfound.com/u/peter-boling
[💖✌️wellfound-img]: https://img.shields.io/badge/peter--boling-orange?style=flat&logo=wellfound
[💖💲crunchbase]: https://www.crunchbase.com/person/peter-boling
[💖💲crunchbase-img]: https://img.shields.io/badge/peter--boling-purple?style=flat&logo=crunchbase
[💖🐘ruby-mast]: https://ruby.social/@galtzo
[💖🐘ruby-mast-img]: https://img.shields.io/mastodon/follow/109447111526622197?domain=https://ruby.social&style=flat&logo=mastodon&label=Ruby%20@galtzo
[💖🦋bluesky]: https://bsky.app/profile/galtzo.com
[💖🦋bluesky-img]: https://img.shields.io/badge/@galtzo.com-0285FF?style=flat&logo=bluesky&logoColor=white
[💖🌳linktree]: https://linktr.ee/galtzo
[💖🌳linktree-img]: https://img.shields.io/badge/galtzo-purple?style=flat&logo=linktree
[💖💁🏼‍♂️devto]: https://dev.to/galtzo
[💖💁🏼‍♂️devto-img]: https://img.shields.io/badge/dev.to-0A0A0A?style=flat&logo=devdotto&logoColor=white
[💖💁🏼‍♂️aboutme]: https://about.me/peter.boling
[💖💁🏼‍♂️aboutme-img]: https://img.shields.io/badge/about.me-0A0A0A?style=flat&logo=aboutme&logoColor=white
[💖🧊berg]: https://codeberg.org/pboling
[💖🐙hub]: https://github.org/pboling
[💖🛖hut]: https://sr.ht/~galtzo/
[💖🧪lab]: https://gitlab.com/pboling
[👨🏼‍🏫expsup-upwork]: https://www.upwork.com/freelancers/~014942e9b056abdf86?mp_source=share
[👨🏼‍🏫expsup-upwork-img]: https://img.shields.io/badge/UpWork-13544E?style=for-the-badge&logo=Upwork&logoColor=white
[👨🏼‍🏫expsup-codementor]: https://www.codementor.io/peterboling?utm_source=github&utm_medium=button&utm_term=peterboling&utm_campaign=github
[👨🏼‍🏫expsup-codementor-img]: https://img.shields.io/badge/CodeMentor-Get_Help-1abc9c?style=for-the-badge&logo=CodeMentor&logoColor=white
[🏙️entsup-tidelift]: https://tidelift.com/subscription/pkg/rubygems-kettle-soup-cover?utm_source=rubygems-kettle-soup-cover&utm_medium=referral&utm_campaign=readme
[🏙️entsup-tidelift-img]: https://img.shields.io/badge/Tidelift_and_Sonar-Enterprise_Support-FD3456?style=for-the-badge&logo=sonar&logoColor=white
[🏙️entsup-tidelift-sonar]: https://blog.tidelift.com/tidelift-joins-sonar
[💁🏼‍♂️peterboling]: http://www.peterboling.com
[🚂railsbling]: http://www.railsbling.com
[📜src-gl-img]: https://img.shields.io/badge/GitLab-FBA326?style=for-the-badge&logo=Gitlab&logoColor=orange
[📜src-gl]: https://gitlab.com/kettle-dev/kettle-soup-cover
[📜src-cb-img]: https://img.shields.io/badge/CodeBerg-4893CC?style=for-the-badge&logo=CodeBerg&logoColor=blue
[📜src-cb]: https://codeberg.org/kettle-dev/kettle-soup-cover
[📜src-gh-img]: https://img.shields.io/badge/GitHub-238636?style=for-the-badge&logo=Github&logoColor=green
[📜src-gh]: https://github.com/kettle-dev/kettle-soup-cover
[📜docs-cr-rd-img]: https://img.shields.io/badge/RubyDoc-Current_Release-943CD2?style=for-the-badge&logo=readthedocs&logoColor=white
[📜docs-head-rd-img]: https://img.shields.io/badge/YARD_on_Galtzo.com-HEAD-943CD2?style=for-the-badge&logo=readthedocs&logoColor=white
[📜gl-wiki]: https://gitlab.com/kettle-dev/kettle-soup-cover/-/wikis/home
[📜gh-wiki]: https://github.com/kettle-dev/kettle-soup-cover/wiki
[📜gl-wiki-img]: https://img.shields.io/badge/wiki-gitlab-943CD2.svg?style=for-the-badge&logo=gitlab&logoColor=white
[📜gh-wiki-img]: https://img.shields.io/badge/wiki-github-943CD2.svg?style=for-the-badge&logo=github&logoColor=white
[👽dl-rank]: https://bestgems.org/gems/kettle-soup-cover
[👽dl-ranki]: https://img.shields.io/gem/rd/kettle-soup-cover.svg
[👽version]: https://bestgems.org/gems/kettle-soup-cover
[👽versioni]: https://img.shields.io/gem/v/kettle-soup-cover.svg
[🏀qlty-mnt]: https://qlty.sh/gh/kettle-dev/projects/kettle-soup-cover
[🏀qlty-mnti]: https://qlty.sh/gh/kettle-dev/projects/kettle-soup-cover/maintainability.svg
[🏀qlty-cov]: https://qlty.sh/gh/kettle-dev/projects/kettle-soup-cover/metrics/code?sort=coverageRating
[🏀qlty-covi]: https://qlty.sh/gh/kettle-dev/projects/kettle-soup-cover/coverage.svg
[🏀codecov]: https://codecov.io/gh/kettle-dev/kettle-soup-cover
[🏀codecovi]: https://codecov.io/gh/kettle-dev/kettle-soup-cover/graph/badge.svg
[🏀coveralls]: https://coveralls.io/github/kettle-dev/kettle-soup-cover?branch=main
[🏀coveralls-img]: https://coveralls.io/repos/github/kettle-dev/kettle-soup-cover/badge.svg?branch=main
[🚎ruby-3.2-wf]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/ruby-3.2.yml
[🚎ruby-3.3-wf]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/ruby-3.3.yml
[🚎ruby-3.4-wf]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/ruby-3.4.yml
[🚎jruby-10.0-wf]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/jruby-10.0.yml
[🚎truby-24.2-wf]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/truffleruby-24.2.yml
[🚎truby-25.0-wf]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/truffleruby-25.0.yml
[🚎truby-33.0-wf]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/truffleruby-33.0.yml
[🚎2-cov-wf]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/coverage.yml
[🚎2-cov-wfi]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/coverage.yml/badge.svg
[🚎3-hd-wf]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/heads.yml
[🚎3-hd-wfi]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/heads.yml/badge.svg
[🚎5-st-wf]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/style.yml
[🚎5-st-wfi]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/style.yml/badge.svg
[🚎9-t-wf]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/truffle.yml
[🚎9-t-wfi]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/truffle.yml/badge.svg
[🚎10-j-wf]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/jruby.yml
[🚎10-j-wfi]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/jruby.yml/badge.svg
[🚎11-c-wf]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/current.yml
[🚎11-c-wfi]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/current.yml/badge.svg
[🚎12-crh-wf]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/dep-heads.yml
[🚎12-crh-wfi]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/dep-heads.yml/badge.svg
[🚎13-🔒️-wf]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/locked_deps.yml
[🚎13-🔒️-wfi]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/locked_deps.yml/badge.svg
[🚎14-🔓️-wf]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/unlocked_deps.yml
[🚎14-🔓️-wfi]: https://github.com/kettle-dev/kettle-soup-cover/actions/workflows/unlocked_deps.yml/badge.svg
[💎ruby-3.2i]: https://img.shields.io/badge/Ruby-3.2-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.3i]: https://img.shields.io/badge/Ruby-3.3-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.4i]: https://img.shields.io/badge/Ruby-3.4-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-c-i]: https://img.shields.io/badge/Ruby-current-CC342D?style=for-the-badge&logo=ruby&logoColor=green
[💎ruby-headi]: https://img.shields.io/badge/Ruby-HEAD-CC342D?style=for-the-badge&logo=ruby&logoColor=blue
[💎truby-24.2i]: https://img.shields.io/badge/Truffle_Ruby-24.2-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-25.0i]: https://img.shields.io/badge/Truffle_Ruby-25.0-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-33.0i]: https://img.shields.io/badge/Truffle_Ruby-33.0-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-c-i]: https://img.shields.io/badge/Truffle_Ruby-current-34BCB1?style=for-the-badge&logo=ruby&logoColor=green
[💎truby-headi]: https://img.shields.io/badge/Truffle_Ruby-HEAD-34BCB1?style=for-the-badge&logo=ruby&logoColor=blue
[💎jruby-10.0i]: https://img.shields.io/badge/JRuby-10.0-FBE742?style=for-the-badge&logo=ruby&logoColor=red
[💎jruby-c-i]: https://img.shields.io/badge/JRuby-current-FBE742?style=for-the-badge&logo=ruby&logoColor=green
[💎jruby-headi]: https://img.shields.io/badge/JRuby-HEAD-FBE742?style=for-the-badge&logo=ruby&logoColor=blue
[🤝gh-issues]: https://github.com/kettle-dev/kettle-soup-cover/issues
[🤝gh-pulls]: https://github.com/kettle-dev/kettle-soup-cover/pulls
[🤝gl-issues]: https://gitlab.com/kettle-dev/kettle-soup-cover/-/issues
[🤝gl-pulls]: https://gitlab.com/kettle-dev/kettle-soup-cover/-/merge_requests
[🤝cb-issues]: https://codeberg.org/kettle-dev/kettle-soup-cover/issues
[🤝cb-pulls]: https://codeberg.org/kettle-dev/kettle-soup-cover/pulls
[🤝cb-donate]: https://donate.codeberg.org/
[🤝contributing]: https://github.com/kettle-dev/kettle-soup-cover/blob/main/CONTRIBUTING.md
[🏀codecov-g]: https://codecov.io/gh/kettle-dev/kettle-soup-cover/graph/badge.svg
[🖐contrib-rocks]: https://contrib.rocks
[🖐contributors]: https://github.com/kettle-dev/kettle-soup-cover/graphs/contributors
[🖐contributors-img]: https://contrib.rocks/image?repo=kettle-dev/kettle-soup-cover
[🚎contributors-gl]: https://gitlab.com/kettle-dev/kettle-soup-cover/-/graphs/main
[🪇conduct]: https://github.com/kettle-dev/kettle-soup-cover/blob/main/CODE_OF_CONDUCT.md
[🪇conduct-img]: https://img.shields.io/badge/Contributor_Covenant-2.1-259D6C.svg
[📌pvc]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint
[📌semver]: https://semver.org/spec/v2.0.0.html
[📌semver-img]: https://img.shields.io/badge/semver-2.0.0-259D6C.svg?style=flat
[📌semver-breaking]: https://github.com/semver/semver/issues/716#issuecomment-869336139
[📌major-versions-not-sacred]: https://tom.preston-werner.com/2022/05/23/major-version-numbers-are-not-sacred.html
[📌changelog]: https://github.com/kettle-dev/kettle-soup-cover/blob/main/CHANGELOG.md
[📗keep-changelog]: https://keepachangelog.com/en/1.0.0/
[📗keep-changelog-img]: https://img.shields.io/badge/keep--a--changelog-1.0.0-34495e.svg?style=flat
[📌gitmoji]: https://gitmoji.dev
[📌gitmoji-img]: https://img.shields.io/badge/gitmoji_commits-%20%F0%9F%98%9C%20%F0%9F%98%8D-34495e.svg?style=flat-square
[🧮kloc]: https://www.youtube.com/watch?v=dQw4w9WgXcQ
[🧮kloc-img]: https://img.shields.io/badge/KLOC-0.247-FFDD67.svg?style=for-the-badge&logo=YouTube&logoColor=blue
[🔐security]: https://github.com/kettle-dev/kettle-soup-cover/blob/main/SECURITY.md
[🔐security-img]: https://img.shields.io/badge/security-policy-259D6C.svg?style=flat
[📄copyright-notice-explainer]: https://opensource.stackexchange.com/questions/5778/why-do-licenses-such-as-the-mit-license-specify-a-single-year
[📄license]: LICENSE.md
[📄license-ref]: AGPL-3.0-only.md
[📄license-img]: https://img.shields.io/badge/License-AGPL--3.0--only-259D6C.svg
[📄license-compat]: https://www.apache.org/legal/resolved.html#category-x
[📄license-compat-img]: https://img.shields.io/badge/Apache_Incompatible:_Category_X-%E2%9C%97-C0392B.svg?style=flat&logo=Apache

[📄ilo-declaration]: https://www.ilo.org/declaration/lang--en/index.htm
[📄ilo-declaration-img]: https://img.shields.io/badge/ILO_Fundamental_Principles-✓-259D6C.svg?style=flat
[🚎yard-current]: http://rubydoc.info/gems/kettle-soup-cover
[🚎yard-head]: https://kettle-soup-cover.galtzo.com
[💎stone_checksums]: https://github.com/galtzo-floss/stone_checksums
[💎SHA_checksums]: https://gitlab.com/kettle-dev/kettle-soup-cover/-/tree/main/checksums
[💎rlts]: https://github.com/rubocop-lts/rubocop-lts
[💎rlts-img]: https://img.shields.io/badge/code_style_&_linting-rubocop--lts-34495e.svg?plastic&logo=ruby&logoColor=white
[💎appraisal2]: https://github.com/appraisal-rb/appraisal2
[💎appraisal2-img]: https://img.shields.io/badge/appraised_by-appraisal2-34495e.svg?plastic&logo=ruby&logoColor=white
[💎d-in-dvcs]: https://railsbling.com/posts/dvcs/put_the_d_in_dvcs/

<!-- kettle-jem:metadata:start -->
| Field | Value |
|---|---|
| Package | kettle-soup-cover |
| Description | 🥘 A Covered Kettle of Test Coverage SOUP (Software of Unknown Provenance)<br>Four-line SimpleCov config, w/ curated, opinionated, pre-configured, dependencies<br>for every CI platform, batteries included.<br>Fund overlooked open source projects - bottom of stack, dev/test dependencies: floss-funding.dev |
| Homepage | https://github.com/kettle-dev/kettle-soup-cover |
| Source | https://github.com/kettle-dev/kettle-soup-cover |
| License | `AGPL-3.0-only` |
| Funding | https://github.com/sponsors/pboling, https://issuehunt.io/u/pboling, https://ko-fi.com/pboling, https://liberapay.com/pboling/donate, https://opencollective.com/kettle-dev, https://opencollective.com/kettle-rb, https://patreon.com/galtzo, https://polar.sh/pboling, https://thanks.dev/u/gh/pboling, https://tidelift.com/funding/github/rubygems/kettle-soup-cover, https://www.buymeacoffee.com/pboling |
<!-- kettle-jem:metadata:end -->
