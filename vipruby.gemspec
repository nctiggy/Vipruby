Gem::Specification.new do |s|
  s.name        = 'vipruby'
  s.version     = '0.1.4'
  s.date        = '2014-08-20'
  s.summary     = "A Ruby Library for EMC's ViPR"
  s.description = "Currently limited to host and initiator add functions along with vCenter and storage additions"
  s.authors     = ["Craig J Smith", "Kendrick Coleman"]
  s.email       = 'nctiggy@gmail.com'
  s.files       = ["lib/vipruby.rb"]
  s.homepage    =
    'https://github.com/nctiggy/Vipruby'
  s.license       = 'MIT'
  s.add_runtime_dependency "json",
    ["~> 1.8"]
  s.add_runtime_dependency "rest-client",
    ["= 1.7.2"]
  s.add_runtime_dependency "nokogiri",
    [">= 1.6.0"]
end