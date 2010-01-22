Gem::Specification.new do |s|
  s.name              = "mg"
  s.version           = "0.0.6"
  s.date              = "2009-11-06"
  s.summary           = "minimal gem"
  s.description       = "minimal gem"
  s.homepage          = "http://github.com/sr/mg"
  s.email             = "simon@rozet.name"
  s.authors           = [
    "Ryan Tomayko",
    "Simon Rozet",
    "Nicolas Sanguinetti",
    "Chris Wanstrath"
  ]
  s.has_rdoc          = false
  s.files             = %w[README.mkd lib/mg.rb]
  s.add_dependency "rake"
end
