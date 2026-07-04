# frozen_string_literal: true

require "version_gem"
require_relative "version"

Kettle::Soup::Cover::Version.class_eval do
  extend VersionGem::Basic
end
