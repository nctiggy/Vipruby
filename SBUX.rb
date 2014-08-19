require 'parseconfig'
require 'Vipruby'

config = ParseConfig.new('settings.conf')

vipr = Vipruby.new(config['base_url'],config['user_name'],config['password'],config['verify_cert'])

host = Host.new(type: 'other',name: 'test',fqdn: 'test.sbux.com',initiator_node: '10:13:27:65:60:38:68:BE',initiators_port: ['10:13:27:65:60:38:68:BD','10:13:27:65:60:38:68:BC'],protocol: 'fc',discoverable: 'false')

vipr.add_host_and_initiators(host) unless vipr.host_exists?(host.name)