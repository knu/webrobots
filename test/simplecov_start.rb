require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
] unless RUBY_PLATFORM == 'java' && ENV['TRAVIS']

SimpleCov.start
