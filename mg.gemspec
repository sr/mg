Gem::Specification.new do |s|
  s.name              = "mg"
  s.version           = "0.0.3"
  s.date              = "2009-05-17"
  s.summary           = "minimal gem"
  s.description       = "minimal gem"
  s.homepage          = "http://github.com/sr/mg"
  s.email             = "simon@rozet.name"
  s.authors           = ["Simon Rozet"]
  s.has_rdoc          = false
  s.files             = %w[README.mkd lib/mg.rb test/mg_test.rb]
  s.test_files        = %w[test/mg_test.rb]
  s.add_dependency "rake"
end
