#Vipruby
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

####Methods:
-vipr.add_host  
-vipr.add_initiators  
-vipr.add_host_and_initators  
-vipr.host_exists?  
