# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "epilotto_curriculum/version"

Gem::Specification.new do |s|
  s.name          = "epilotto_curriculum"
  s.version       = EpilottoCurriculum::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Enrico Pilotto"]
  s.email         = ["enrico@megiston.it"]
  s.homepage      = "http://github.com/pioz/epilotto_curriculum"
  s.summary       = "Get Enrico Pilotto's Curriculm Vitae typing 'epilotto' from your terminal"
  s.description   = s.summary
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency('term-ansicolor', '>= 1.0.5')
end
