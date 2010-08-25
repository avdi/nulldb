require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'activerecord-nulldb-adapter'
    gem.summary = %Q{The Null Object pattern as applied to ActiveRecord database adapters}
    gem.description = %Q{A database backend that translates database interactions into no-ops. Using NullDB enables you to test your model business logic - including after_save hooks - without ever touching a real database.}
    gem.email = "myron.marston@gmail.com"
    gem.homepage = "http://github.com/nulldb/nulldb"
    gem.authors = ["Avdi Grimm", "Myron Marston"]
    gem.rubyforge_project = "nulldb"

    gem.add_dependency 'activerecord', '>= 2.0.0'
    gem.add_development_dependency "rspec", ">= 1.2.9"

    gem.files.exclude 'vendor/ginger'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "rdoc"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

# We want to test ActiveRecord 3 against RSpec 2.x, and
# prior versions of AR against RSpec 1.x.  The task
# definitions are different, and in order to allow ginger
# to invoke a single task (:spec_for_ginger) that runs the
# specs against the right version of RSpec, we dynamically
# define the spec task with this method.
def define_specs_task
  require 'active_record/version'

  if ActiveRecord::VERSION::MAJOR > 2
    # rspec 2
    require "rspec/core/rake_task"
    RSpec::Core::RakeTask.new(:specs) do |spec|
      spec.pattern = "spec/*_spec.rb"
    end
  else
    # rspec 1
    require 'spec/rake/spectask'
    Spec::Rake::SpecTask.new(:specs) do |spec|
      spec.libs << 'lib' << 'spec'
      spec.spec_files = FileList['spec/**/*_spec.rb']
    end
  end
end

desc "Run the specs"
task :spec do
  define_specs_task
  Rake::Task[:specs].invoke
end

task :spec_for_ginger do
  $LOAD_PATH << File.join(*%w[vendor ginger lib])
  require 'ginger'
  define_specs_task
  Rake::Task[:specs].invoke
end

task :spec => :check_dependencies if defined?(Jeweler)

desc 'Run ginger tests'
task :ginger do
  $LOAD_PATH << File.join(*%w[vendor ginger lib])
  ARGV.clear
  ARGV << 'spec_for_ginger'
  load File.join(*%w[vendor ginger bin ginger])
end

task :default => :ginger

require 'rake/rdoctask'
Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "LICENSE", "lib/**/*.rb")
end

desc "Publish project home page"
task :publish => ["rdoc"] do
  sh "scp -r html/* myronmarston@rubyforge.org:/var/www/gforge-projects/nulldb"
end
