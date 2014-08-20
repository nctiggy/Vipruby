require 'Vipruby'

base_url = 'https://192.168.50.141:4443'
port = '4443'
user_name = 'root'
password = 'u1805003'
verify_cert = false

vipr = Vipruby.new(base_url,user_name,password,verify_cert)
puts "success"

#puts vipr.get_hosts

#vcenter_id = vipr.get_all_vcenters['id'][0]
#puts vipr.get_vcenter(vcenter_id)
puts vipr.find_vcenter_object("kcv")
puts vipr.find_host_object("esxi01")