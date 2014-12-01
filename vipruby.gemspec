

Gem::Specification.new do |s|
  s.name        = 'vipruby'
  s.version     = '0.1.5'
  s.date        = '2014-08-20'
  s.summary     = "A Ruby Library for EMC's ViPR"
  s.description = "Currently limited to host and initiator add functions along with vCenter and storage additions"
  s.authors     = ["Craig J Smith", "Kendrick Coleman"]
  s.email       = 'nctiggy@gmail.com'
  s.require_paths = %w[lib]
  s.files       = ["lib/vipruby.rb", "lib/vipruby/version.rb", "lib/vipruby/vipr.rb", "lib/vipruby/viprbase.rb",  "lib/vipruby/objects/vcenter.rb", 
  "lib/vipruby/objects/emc_block.rb", "lib/vipruby/objects/emc_file.rb", "lib/vipruby/objects/hitachi.rb", "lib/vipruby/objects/isilon.rb", 
  "lib/vipruby/objects/netapp.rb", "lib/vipruby/objects/scaleio.rb", "lib/vipruby/objects/thirdpartyblock.rb", "lib/vipruby/objects/vplex.rb", "README.md"]
  s.homepage    =
    'https://github.com/nctiggy/Vipruby'
  s.license       = 'MIT'
  s.add_runtime_dependency "json",
    ["~> 1.8"]
  s.add_runtime_dependency "rest-client",
    ["= 1.7.2"]
end