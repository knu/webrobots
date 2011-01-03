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
#  gem.homepage = "http://github.com/knu/webrobots"
  gem.license = "2-clause BSDL"
  gem.summary = %Q{A Ruby library to help write robots.txt compliant web robots}
  gem.description = <<-'EOS'
This library helps write robots.txt compliant web robots in Ruby.
  EOS
  gem.email = "knu@idaemons.org"
  gem.authors = ["Akinori MUSHA"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  gem.add_development_dependency 'racc'
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
