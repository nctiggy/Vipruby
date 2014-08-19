#Vipruby 0.0.2
Ruby Library for ViPR  

####Install and usage:
gem install vipruby  
require 'vipruby'  


####Example usage files:
-SBUX.rb  
-settings.conf  


####Create a vipr object:
    vipr = Vipruby.new([base_url]:[port],[user],[password])

####Create a host object:
	host = Host.new(type: 'other',name: [name],fqdn: [fqdn],initiator_node: [wwnn],initiators_port: ['WWPN1','WWPN2'],protocol: [fc/iscsi],discoverable: [true/false])

####Methods that matter:
vipr.add_host(*hostObject.generate_json*)  
vipr.add_initiators(*hostObject.generate_initiators_json*,*host_href*)  
vipr.add_host_and_initators(*hostObject*)  
vipr.host_exists?(*hostObject.name*)  