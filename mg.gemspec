Gem::Specification.new do |s|
  s.name              = "mg"
  s.version           = "0.0.1"
  s.date              = "2009-03-15"
  s.summary           = "Minimalistic Gem"
  s.homepage          = "http://github.com/sr/mg"
  s.email             = "simon@rozet.name"
  s.authors           = ["Simon Rozet"]
  s.has_rdoc          = false
  s.files             = %w[lib/mg.rb test/mg_test.rb]
  s.test_files        = %w[test/mg_test.rb]
  s.add_dependency "rake"
end
