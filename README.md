[![Gem Version](https://badge.fury.io/rb/vipruby.svg)](http://badge.fury.io/rb/vipruby)  
#Vipruby 0.1.4
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

####Add a vCenter Server:
	vipr.add_vcenter(fqdn_or_ip, name, port, user_name, password)
	ex. vipr.add_vcenter('vcenter.mycompany.com', 'Company-vCenter', '443', 'CORP\user', 'mypassword')

####Delete a vCenter Server:
	vipr.delete_vcenter(vcenter_id)

	ex1. vcenter_id = vipr.get_all_vcenters['id'][0] 
	or
	ex2. myvc = vipr.find_vcenter_object("myvc")
	ex2. vcenter_id = vcenter_id['resource'][0]['id']

####Add Storage:
	Will figure out a better way to show each method... YARD?

####Methods that matter:
vipr.add_host(*hostObject.generate_json*)  
vipr.add_initiators(*hostObject.generate_initiators_json*,*host_href*)  
vipr.add_host_and_initators(*hostObject*)  
vipr.host_exists?(*hostObject.name*)  
vipr.find_host_object(*hostObject.name*)
vipr.get_all_hosts  
vipr.get_host(*host_href*)  
vipr.get_all_hosts  
vipr.deactivate_host(*host_href*)
vipr.add_vcenter(fqdn_or_ip, name, port, user_name, password)
vipr.delete_vcenter(vcenter_id)

####Fun facts
To get a host href -> vipr.find_host_object(host.name)['resource'][0]['link']['href']

##To Do:
- Breakout vipruby.rb into multiple classes and files. Host, Vcenter, Storage, Filesystems, Snapshots, etc... it's already getting large
- Add more and more and more things
- figure out if adding by JSON or XML is easier for future proof.
- Add documentation via Yard
- 
