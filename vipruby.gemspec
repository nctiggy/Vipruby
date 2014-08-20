Gem::Specification.new do |s|
  s.name        = 'vipruby'
  s.version     = '0.1.3'
  s.date        = '2014-08-19'
  s.summary     = "A Ruby Library for EMC's ViPR"
  s.description = "Currently limited to host and initiator add functions"
  s.authors     = ["Craig J Smith"]
  s.email       = 'nctiggy@gmail.com'
  s.files       = ["lib/vipruby.rb"]
  s.homepage    =
    'https://github.com/nctiggy/Vipruby'
  s.license       = 'MIT'
  s.add_runtime_dependency "json",
    ["~> 1.8"]
  s.add_runtime_dependency "rest-client",
    ["= 1.7.2"]
end