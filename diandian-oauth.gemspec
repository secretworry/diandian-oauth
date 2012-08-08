Gem::Specification.new do |s|
  s.name        = 'diandian-oauth'
  s.version     = '0.1.1'
  s.date        = '2012-07-24'
  s.summary     = "Client for diandian API"
  s.description = "A Ruby Client for diandian API"
  s.authors     = ["Rainer Du"]
  s.email       = 'dusiyu@diandian.com'
  s.files       = ["lib/diandian_oauth.rb"]
  s.homepage    = 'https://github.com/secretworry/diandian-oauth'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency("oauth2", '~> 0.8.0')
  s.add_dependency("activemodel", '~> 3.2.6')
  s.add_dependency("activesupport", '~> 3.2.1')
end
