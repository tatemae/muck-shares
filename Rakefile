require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rspec/core/rake_task'

desc 'Default: run specs.'
task :default => :spec
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ["--color", "-c", "-f progress", "-r test/spec/spec_helper.rb"]
  t.pattern = 'test/spec/**/*_spec.rb'  
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    #t.libs << 'lib'
    t.libs << 'test/lib'
    t.pattern = 'test/test/**/*_spec.rb'
    t.verbose = true
    t.output_dir = 'coverage'
    t.rcov_opts << '--exclude "gems/*"'
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

desc 'Generate documentation for the muck-shares gem.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'MuckShares'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Translate this gem'
task :translate do
  file = File.join(File.dirname(__FILE__), 'config', 'locales', 'en.yml')
  system("babelphish -o -y #{file}")
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "muck-shares"
    gem.summary = "The share engine for the muck system"
    gem.email = "justin@tatemae.com"
    gem.homepage = "http://github.com/tatemae/muckshares"
    gem.description = "The share engine for the muck system."
    gem.authors = ["Justin Ball", "Joel Duffin"]
    
    gem.add_dependency "muck-engine"
    gem.add_dependency "muck-users"
    gem.add_dependency "muck-activities"
    gem.add_dependency "muck-comments"
    gem.add_dependency "muck-invites"
    gem.files.exclude 'test/**'
    gem.test_files.exclude 'test/**'
  end
  Jeweler::GemcutterTasks.new
  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "rdoc"
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end
