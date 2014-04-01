Gem::Specification.new do |s|
  s.name    = "cleversafe"
  s.summary = "A Ruby API into Cleversafe's REST interface."
  s.author  = "John Williams"
  s.email   = "john@37signals.com"
  s.version = "1.1.9"

  s.add_dependency 'json'
  s.add_dependency 'rest-client', '~> 1.6.9'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'webmock', '~> 1.7.6'

  s.files = Dir["#{File.dirname(__FILE__)}/**/*"]
end
