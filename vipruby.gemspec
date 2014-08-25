Gem::Specification.new do |s|
  s.name        = 'vipruby'
  s.version     = '0.1.5'
  s.date        = '2014-08-20'
  s.summary     = "A Ruby Library for EMC's ViPR"
  s.description = "Currently limited to host and initiator add functions along with vCenter and storage additions"
  s.authors     = ["Craig J Smith", "Kendrick Coleman"]
  s.email       = 'nctiggy@gmail.com'
  s.require_paths = %w[lib]
  s.files       = ["lib/vipruby.rb", "lib/vipruby/restcall", "lib/vipruby/objects/vcenter", "lib/vipruby/objects/emc_block", "lib/vipruby/objects/emc_file", 
  "lib/vipruby/objects/hitachi", "lib/vipruby/objects/isilon", "lib/vipruby/objects/netapp", "lib/vipruby/objects/scaleio", 
  "lib/vipruby/objects/thirdpartyblock", "lib/vipruby/objects/vplex", "README.md"]
  s.homepage    =
    'https://github.com/nctiggy/Vipruby'
  s.license       = 'MIT'
  s.add_runtime_dependency "json",
    ["~> 1.8"]
  s.add_runtime_dependency "rest-client",
    ["= 1.7.2"]
end