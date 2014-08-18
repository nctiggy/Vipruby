Gem::Specification.new do |s|
  s.name        = 'vipruby'
  s.version     = '0.0.1'
  s.date        = '2014-08-17'
  s.summary     = "A Ruby Library for EMC's ViPR"
  s.description = "Currently limited to host and initiator adding functions"
  s.authors     = ["Craig J Smith"]
  s.email       = 'nctiggy@gmail.com'
  s.files       = ["lib/vipruby.rb"]
  s.homepage    =
    'http://rubygems.org/gems/vipruby'
  s.license       = 'MIT'
  s.add_runtime_dependency "json",
    ["~> 0"]
  s.add_runtime_dependency "rest_client",
    ["= 1.7.2"]
end