Gem::Specification.new do |s|
  s.name    = "cleversafe"
  s.summary = "A Ruby API into Cleversafe's REST interface."
  s.author  = "John Williams"
  s.email   = "john@37signals.com"
  s.version = "1.0.7"

  s.add_dependency 'rest-client'

  s.files = Dir['lib/**/*']
end
