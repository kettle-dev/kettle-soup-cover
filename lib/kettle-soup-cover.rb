# rubocop:disable Naming/FileName
# USAGE:
# In your `spec/spec_helper.rb`,
# just prior to loading the library under test:
#
#   require "kettle-soup-cover"
#
# In your `.simplecov` file:
#
#   require "kettle/soup/cover/config"
#
# In your `spec/spec_helper.rb`,
# after requiring SimpleCov:
#
#   SimpleCov.start
#

# For technical reasons, if we move to Zeitwerk, this cannot be require_relative.
#   See: https://github.com/fxn/zeitwerk#for_gem_extension
# Hook for other libraries to load this library (e.g. via bundler)
require "kettle/soup/cover"
# rubocop:enable Naming/FileName
