# coding: utf-8

Gem::Specification.new do |s|
  s.name = "activerecord-nulldb-adapter"
  s.version = "0.3.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Avdi Grimm", "Myron Marston"]
  s.date = "2016-09-26"
  s.description = "A database backend that translates database interactions into no-ops. Using NullDB enables you to test your model business logic - including after_save hooks - without ever touching a real database."
  s.email = "myron.marston@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files    = `git ls-files`.split($/)
  s.homepage = "http://github.com/nulldb/nulldb"
  s.licenses = ["MIT"]
  s.rubyforge_project = "nulldb"
  s.rubygems_version = "2.4.8"
  s.summary = "The Null Object pattern as applied to ActiveRecord database adapters"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 2.0.0"])
      s.add_development_dependency(%q<spec>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<appraisal>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, [">= 2.0.0"])
      s.add_dependency(%q<spec>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<appraisal>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 2.0.0"])
    s.add_dependency(%q<spec>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<appraisal>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
  end
end

