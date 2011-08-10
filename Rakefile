# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "webrobots"
  gem.homepage = "https://github.com/knu/webrobots"
  gem.license = "2-clause BSDL"
  gem.summary = %Q{A Ruby library to help write robots.txt compliant web robots}
  gem.description = <<-'EOS'
This library helps write robots.txt compliant web robots in Ruby.
  EOS
  gem.email = "knu@idaemons.org"
  gem.authors = ["Akinori MUSHA"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
  test.rcov_opts << '--exclude "gems/*"'
end

task :default => :test

task :test => 'lib/webrobots/robotstxt.rb'

file 'lib/webrobots/robotstxt.rb' => 'lib/webrobots/robotstxt.ry' do
  sh 'racc', '-o', 'lib/webrobots/robotstxt.rb', 'lib/webrobots/robotstxt.ry'
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "webrobots #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
