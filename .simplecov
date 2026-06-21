# kettle-jem:freeze
# To retain chunks of comments & code during kettle-soup-cover templating:
# Wrap custom sections with freeze markers (e.g., as above and below this comment chunk).
# kettle-soup-cover will then preserve content between those markers across template runs.
# kettle-jem:unfreeze

# In other gems we would simply check if Kettle::Soup::Cover::DO_COV
#   but because this is that library, and we can't load it before we start SimpleCov,
#   it isn't available here, so we fall back to the raw ENV variable check.
if ENV.fetch("K_SOUP_COV_DO", "false").casecmp?("true")
  SimpleCov.configure do
    # coverage config is loaded when the test suite runs, so it is under dog food testing.
    skip "lib/kettle/soup/cover/config"
    cover "lib/**/*.rb", "lib/**/*.rake", "exe/*.rb"
  end
end
