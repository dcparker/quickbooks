require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'

PKG_VERSION = "0.0.2"

PKG_FILES = FileList[
    "lib/**/*", "test/**/*", "[A-Z]*", "Rakefile", "doc/**/*"
]

desc "Default Task"
task :default => [ :test ]

# Run the unit tests
desc "Run all unit tests"
Rake::TestTask.new("test") { |t|
  t.libs << "lib"
  t.pattern = 'test/*/*_test.rb'
  t.verbose = true
}

# Make a console, useful when working on tests
desc "Generate a test console"
task :console do
   verbose( false ) { sh "irb -I lib/ -r 'quickbooks'" }
end

# Genereate the RDoc documentation
desc "Create documentation"
Rake::RDocTask.new("doc") { |rdoc|
  rdoc.title = "QuickBooks for Ruby"
  rdoc.rdoc_dir = 'doc'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('LICENSE')
  rdoc.rdoc_files.include('lib/**/*.rb')
}

# Genereate the package
spec = Gem::Specification.new do |s|

  #### Basic information.

  s.name = 'quickbooks'
  s.version = PKG_VERSION
  s.summary = <<-EOF
   A module to connect to QuickBooks through the QuickBooks SDK.
  EOF
  s.description = <<-EOF
   A module to connect to QuickBooks and QuickBooks Merchant Services through the QuickBooks SDK.
  EOF

  #### Which files are to be included in this gem?  Everything!  (Except CVS directories.)

  s.files = PKG_FILES

  #### Load-time details: library and application (you will need one or both).

  s.require_path = 'lib'
  s.autorequire = 'quickbooks'

  #### Documentation and testing.

  s.has_rdoc = true

  #### Author and project details.

  s.author = "Chris Bruce"
  s.email = "chrisabruce@yahoo.com"
  s.homepage = "http://quickbooks.rubyforge.org"
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = false
end

desc "Report code statistics (KLOCs, etc) from the application"
task :stats do
  require 'code_statistics'
  CodeStatistics.new(
    ["Library", "lib"],
    ["Units", "test"]
  ).to_s
end

desc "Publish new documentation"
task :publish => [:doc] do
   `pscp -r doc/* rubyforge:/var/www/gforge-projects/quickbooks/`
end