# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record/attr_updated_by/version'

Gem::Specification.new do |spec|
  spec.name          = "active_record-attr_updated_by"
  spec.version       = ActiveRecord::AttrUpdatedBy::VERSION
  spec.authors       = ["Jake Mitchell"]
  spec.email         = ["jakethesnake3p0@gmail.com"]
  spec.summary       = %q{Updates the timestamp of an attribute when associated attributes have changed}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  # spec.add_development_dependency "rails"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "timecop"
end
