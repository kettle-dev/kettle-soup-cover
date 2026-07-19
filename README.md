<a href="https://github.com/kettle-dev"><img alt="kettle-dev Logo by Aboling0, CC BY-SA 4.0" src="https://logos.galtzo.com/assets/images/kettle-dev/avatar-128px.svg" width="12%" align="right"/></a> <a href="https://github.com/kettle-dev/kettle-soup-cover"><img alt="kettle-soup-cover Logo by Aboling0, CC BY-SA 4.0" src="https://logos.galtzo.com/assets/images/kettle-dev/kettle-soup-cover/avatar-128px.svg" width="12%" align="right"/></a>

# 🥘 Kettle::Soup::Cover

[![Version][👽versioni]][👽version] [![GitHub tag (latest SemVer)][⛳️tag-img]][⛳️tag] [![License: AGPL-3.0-only][📄license-img]][📄license] [![Downloads Rank][👽dl-ranki]][👽dl-rank] [![CodeCov Test Coverage][🏀codecovi]][🏀codecov] [![Coveralls Test Coverage][🏀coveralls-img]][🏀coveralls] [![QLTY Test Coverage][🏀qlty-covi]][🏀qlty-cov] [![QLTY Maintainability][🏀qlty-mnti]][🏀qlty-mnt] [![CI Heads][🚎3-hd-wfi]][🚎3-hd-wf] [![CI Runtime Dependencies @ HEAD][🚎12-crh-wfi]][🚎12-crh-wf] [![CI Current][🚎11-c-wfi]][🚎11-c-wf] [![CI Truffle Ruby][🚎9-t-wfi]][🚎9-t-wf] [![CI JRuby][🚎10-j-wfi]][🚎10-j-wf] [![Deps Locked][🚎13-🔒️-wfi]][🚎13-🔒️-wf] [![Deps Unlocked][🚎14-🔓️-wfi]][🚎14-🔓️-wf] [![CI Test Coverage][🚎2-cov-wfi]][🚎2-cov-wf] [![CI Style][🚎5-st-wfi]][🚎5-st-wf]

`if ci_badges.map(&:color).detect { it != "green"}` ☝️ [let me know][✉️discord-invite], as I may have missed the [discord notification][✉️discord-invite].

---

`if ci_badges.map(&:color).all? { it == "green"}` 👇️ send money so I can do more of this. FLOSS maintenance is now my full-time job.

[![OpenCollective Backers][🖇osc-backers-i]][🖇osc-backers] [![OpenCollective Sponsors][🖇osc-sponsors-i]][🖇osc-sponsors] [![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor] [![Liberapay Goal Progress][⛳liberapay-img]][⛳liberapay] [![Donate on PayPal][🖇paypal-img]][🖇paypal] [![Buy me a coffee][🖇buyme-small-img]][🖇buyme] [![Donate at ko-fi.com][🖇kofi-img]][🖇kofi]

<details markdown="1">
 <summary>👣 How will this project approach the September 2025 hostile takeover of RubyGems? 🚑️</summary>

I've summarized my thoughts in [this blog post](https://dev.to/galtzo/hostile-takeover-of-rubygems-my-thoughts-5hlo).

</details>

## 🌻 Synopsis <a href="https://discord.gg/3qme4XHNKN"><img alt="Galtzo FLOSS Logo by Aboling0, CC BY-SA 4.0" src="https://logos.galtzo.com/assets/images/galtzo-floss/avatar-128px.svg" width="8%" align="right"/></a> <a href="https://ruby-toolbox.com"><img alt="ruby-lang Logo, Yukihiro Matsumoto, Ruby Visual Identity Team, CC BY-SA 2.5" src="https://logos.galtzo.com/assets/images/ruby-lang/avatar-128px.svg" width="8%" align="right"/></a>

`kettle-soup-cover` is a 12-factor SimpleCov harness for Ruby projects. It keeps
coverage policy in environment variables, configures branch coverage, loads a
curated formatter stack, isolates `turbo_tests2` worker reports, and can collate
parallel worker output into one final report.

The normal setup is intentionally small:

1. Add the gem to your `:development, :test` bundle with `require: false`.
2. Require `kettle-soup-cover` before loading the app or library under test.
3. Require `simplecov` and call `SimpleCov.start` only when
   `Kettle::Soup::Cover::DO_COV` is true.
4. Put `require "kettle/soup/cover/config"` in `.simplecov`.

That configuration works for RSpec, Minitest, and other Ruby test runners. In CI,
coverage is enabled by default from `CI=true`; locally it stays off unless
`K_SOUP_COV_DO=true` is set. When `turbo_tests2` sets `TEST_ENV_NUMBER`, worker
coverage is written under `coverage/turbo_tests/<worker>` and hard minimum
enforcement is deferred until the parent collation step.

A quick shot of 12-factor coverage power:

```console
export K_SOUP_COV_COMMAND_NAME="RSpec (COVERAGE)" # Display name for the coverage run
export K_SOUP_COV_CLEAN_RESULTSET=true # Delete stale .resultset.json before SimpleCov.start
export K_SOUP_COV_DEBUG=false # Enable debug output for configuration (true/false)
export K_SOUP_COV_DIR=coverage # Root directory where coverage reports are written
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
export K_SOUP_COV_TURBO_TESTS=true # Isolate turbo_tests2 worker coverage when TEST_ENV_NUMBER is set
export K_SOUP_COV_TURBO_TESTS_DIR=turbo_tests # Worker coverage subdirectory below K_SOUP_COV_DIR
export K_SOUP_COV_USE_MERGING=true # Enable merging of results for parallel/test matrix runs (true/false)
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

Configure this gem with environment variables. Variable names use
`K_SOUP_COV_PREFIX`, which defaults to `K_SOUP_COV_`; for example the `DIR`
setting is read from `K_SOUP_COV_DIR`.

| Variable | Default | Purpose |
|----------|---------|---------|
| `CI` | `false` | Standard CI flag. Used as the default for `DO` and `MIN_HARD`. |
| `K_SOUP_COV_CLEAN_RESULTSET` | `true` locally, `false` on CI and in turbo workers | Deletes stale `.resultset.json` before `SimpleCov.start`. Set `false` for spawned subprocess coverage so one process does not wipe another process' resultset. |
| `K_SOUP_COV_COMMAND_NAME` | `RSpec (COVERAGE)` | SimpleCov command name. Workers become `COMMAND_NAME (turbo_tests2 worker N)`. |
| `K_SOUP_COV_DEBUG` | `false` | Enables debug-oriented constants. |
| `K_SOUP_COV_DIR` | `coverage` | Root coverage directory. Workers use `DIR/TURBO_TESTS_DIR/TEST_ENV_NUMBER`. |
| `K_SOUP_COV_DO` | `CI` | Enables the caller's `require "simplecov"` / `SimpleCov.start` block. |
| `K_SOUP_COV_FILTER_DIRS` | `bin,certs,checksums,config,coverage,docs,features,gemfiles,pkg,results,sig,spec,src,test,test-results,vendor` | Comma-separated root directories skipped by SimpleCov. |
| `K_SOUP_COV_FORMATTERS` | `html,xml,rcov,lcov,json,tty` on CI; `html,tty` locally | Formatter list. Supported values are `html`, `xml`, `rcov`, `lcov`, `json`, and `tty`. |
| `K_SOUP_COV_MERGE_TIMEOUT` | `3600` | SimpleCov merge timeout in seconds when merging is enabled. |
| `K_SOUP_COV_MIN_BRANCH` | `80` | Branch coverage minimum. |
| `K_SOUP_COV_MIN_HARD` | `CI` | Fails the run when minimums are missed. Worker processes always defer hard enforcement to collation. |
| `K_SOUP_COV_MIN_LINE` | `80` | Line coverage minimum. |
| `K_SOUP_COV_MULTI_FORMATTERS` | `true` on CI; otherwise `true` when any formatter is configured | Uses SimpleCov's multi-formatter support. |
| `K_SOUP_COV_OPEN_BIN` | `open` on macOS, `xdg-open` elsewhere | Browser-opening command for `rake coverage`. Set empty to only print the report path. |
| `K_SOUP_COV_PREFIX` | `K_SOUP_COV_` | Alternate namespace for all `K_SOUP_COV_*` variables. |
| `K_SOUP_COV_TURBO_TESTS` | `true` | Enables turbo_tests2 worker coverage isolation when `TEST_ENV_NUMBER` is present. |
| `K_SOUP_COV_TURBO_TESTS_DIR` | `turbo_tests` | Subdirectory for worker coverage under `K_SOUP_COV_DIR`. |
| `K_SOUP_COV_USE_MERGING` | `true` | Enables SimpleCov result merging. |
| `K_SOUP_COV_VERBOSE` | `false` | Enables verbose-oriented constants. |
| `MAX_ROWS` | formatter-defined | Passed through to `simplecov-console`; `MAX_ROWS=0` removes the `tty` formatter. |
| `TEST_ENV_NUMBER` | empty | Set by parallel test tools. Non-empty values mark a turbo_tests2 worker. |

## 🔧 Basic Usage

### Gemfile

Use `require: false` so coverage starts exactly where your test helper starts it.
Keep the gem in both `:development` and `:test` if you want the bundled
`coverage` rake task locally.

```ruby
group :development, :test do
  gem "kettle-soup-cover", "~> 3.0", require: false
end
```

### RSpec, Minitest, or another Ruby test runner

In your test helper, require `kettle-soup-cover` before loading the library or
application under test. Start SimpleCov only when `DO_COV` is true:

```ruby
require "kettle-soup-cover"

if Kettle::Soup::Cover::DO_COV
  require "simplecov"
  # Minitest users that rely on SimpleCov's external at_exit handling should set:
  # SimpleCov.external_at_exit = true
  SimpleCov.start
end

# Now load your app or library under test.
require "my_gem"
```

Put the shared SimpleCov configuration in `.simplecov`:

```ruby
require "kettle/soup/cover/config"
```

### Rails and RSpec

In Rails, start coverage after `spec_helper` is loaded and before Rails boots:

```ruby
require "kettle-soup-cover"
require "spec_helper"

ENV["RAILS_ENV"] ||= "test"

if Kettle::Soup::Cover::DO_COV
  require "simplecov"
  SimpleCov.start
end

require File.expand_path("../config/environment", __dir__)
```

### Rake tasks

Define a `test` task, then install this gem's local `coverage` task:

```ruby
require "kettle-soup-cover"
Kettle::Soup::Cover.install_tasks

desc "Run specs through the test task expected by kettle-soup-cover"
task test: :spec
```

`rake coverage` forces coverage on, resets coverage constants through
`kettle-wash`, invokes `test`, and opens `K_SOUP_COV_DIR/index.html` unless
`K_SOUP_COV_OPEN_BIN` is empty.

### turbo_tests2 coverage

When `K_SOUP_COV_TURBO_TESTS=true` and `TEST_ENV_NUMBER` is non-empty,
`kettle-soup-cover` treats the process as a worker:

- `K_SOUP_COV_DIR` remains the root coverage directory.
- worker output goes to `K_SOUP_COV_DIR/K_SOUP_COV_TURBO_TESTS_DIR/TEST_ENV_NUMBER`;
- worker command names include the worker number;
- `SimpleCov.finalize_merge(false)` is applied in workers;
- hard coverage minimums are disabled in workers and enforced during parent collation.

The installed tasks provide both `turbo_tests:*` and `turbo_tests2:*` names:

```ruby
Kettle::Soup::Cover.install_tasks
```

Use `turbo_tests:setup` before workers and `turbo_tests:cleanup` after workers
when your runner does not invoke those hooks automatically.

### Coverage JSON analyzer

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

There are two built-in SimpleCov filters which can be loaded via
`Kettle::Soup::Cover.load_filters`.

You could use them like this:

```ruby
SimpleCov.add_group("Too Long", Kettle::Soup::Cover::Filters::GtLineFilter.new(1000))
```

### Advanced Usage

There are a number of ENV variables that control things within this gem.
All of them can be found, along with their default values, in [lib/kettle/soup/cover/constants.rb][env-constants].

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
- What it controls: Root directory where SimpleCov writes coverage reports. Turbo worker processes write under `K_SOUP_COV_DIR/K_SOUP_COV_TURBO_TESTS_DIR/TEST_ENV_NUMBER`. The `exe/kettle-soup-cover` script and rake tasks look here for artifacts like `coverage.json` or `index.html`.
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

- Default: `false` on CI and in turbo worker processes; `true` locally.
- What it controls: When true, deletes `coverage/.resultset.json` before SimpleCov starts. This prevents stale entries from prior runs (e.g., after a refactor that shifts line/branch numbers) from polluting the current run's coverage report. In CI each job starts from a clean workspace so this is unnecessary; locally developers re-run tests frequently and stale entries accumulate.
- Example: `export K_SOUP_COV_CLEAN_RESULTSET=false`

**Important for spawned-process coverage:** if you use `.simplecov_spawn.rb` (or similar) to collect coverage from child processes, set `K_SOUP_COV_CLEAN_RESULTSET=false` inside that file so spawned processes do not wipe the resultset that other workers are accumulating. Only the main process should clean.

#### K_SOUP_COV_MERGE_TIMEOUT

- Default: `3600`
- What it controls: When using merging (`K_SOUP_COV_USE_MERGING=true`), this sets a numeric timeout in seconds for the merge operation.
- Example: `export K_SOUP_COV_MERGE_TIMEOUT=3600`

#### K_SOUP_COV_MIN_BRANCH

- Default: `80`
- What it controls: Minimum allowed branch coverage percentage. Used to assert that coverage thresholds are met.
- Example: `export K_SOUP_COV_MIN_BRANCH=85`

#### K_SOUP_COV_MIN_HARD

- Default: Uses `CI` if unset (`CI=false` default). Worker processes always use `false`.
- What it controls: Whether failing coverage thresholds should fail the run (hard failure) or only warn. In turbo_tests2 worker processes, hard enforcement is deferred to the parent collation process.
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

#### K_SOUP_COV_TURBO_TESTS

- Default: `true`
- What it controls: Enables turbo_tests2 worker isolation when `TEST_ENV_NUMBER` is non-empty.
- Example: `export K_SOUP_COV_TURBO_TESTS=true`

#### K_SOUP_COV_TURBO_TESTS_DIR

- Default: `turbo_tests`
- What it controls: Subdirectory under `K_SOUP_COV_DIR` for worker coverage output.
- Example: `export K_SOUP_COV_TURBO_TESTS_DIR=parallel`

#### K_SOUP_COV_USE_MERGING

- Default: `true`
- What it controls: When true, enables result merging semantics for multiple test runs (works with merge timeout and other behaviors).
- Example: `export K_SOUP_COV_USE_MERGING=true`

#### K_SOUP_COV_VERBOSE

- Default: `false`
- What it controls: Enables additional verbose logging where supported within tasks and scripts.
- Example: `export K_SOUP_COV_VERBOSE=true`

Note: Some third-party formatters may also read their own environment variables. For example, the simplecov-console formatter supports `MAX_ROWS` to limit the tty output. This is not prefixed with `K_SOUP_COV_` by design and is passed through to the formatter directly.

Additionally, some of the included gems, like [`simplecov-console`][simplecov-console],
have their own complete suite of ENV variables you can configure.

[env-constants]: /lib/kettle/soup/cover/constants.rb
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
[🖇kofi-img]: https://img.shields.io/badge/ko--fi-%E2%9C%93-a51611.svg?style=flat
[🖇kofi]: https://ko-fi.com/pboling
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
[🧮kloc-img]: https://img.shields.io/badge/KLOC-0.243-FFDD67.svg?style=for-the-badge&logo=YouTube&logoColor=blue
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
| Funding | https://github.com/sponsors/pboling, https://ko-fi.com/pboling, https://liberapay.com/pboling/donate, https://opencollective.com/kettle-dev, https://thanks.dev/u/gh/pboling, https://tidelift.com/funding/github/rubygems/kettle-soup-cover, https://www.buymeacoffee.com/pboling |
<!-- kettle-jem:metadata:end -->
