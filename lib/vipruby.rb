require 'rest-client'
require 'json'
require 'nokogiri'

class Vipruby
  attr_accessor :tenant_uid, :auth_token, :base_url, :verify_cert
  #SSL_VERSION = 'TLSv1'
  
  def initialize(base_url,user_name,password,verify_cert)
    @base_url = base_url
    @verify_cert = to_boolean(verify_cert)
    @auth_token = get_auth_token(user_name,password)
    @tenant_uid = get_tenant_uid['id']
  end
  
  def get_tenant_uid
    JSON.parse(RestClient::Request.execute(method: :get,
      url: "#{@base_url}/tenant",
      headers: {:'X-SDS-AUTH-TOKEN' => @auth_token,
        accept: :json
      },
      verify_ssl: @verify_cert
      ))
  end
  
  def login(user_name,password)
    RestClient::Request.execute(method: :get,
      url: "#{@base_url}/login",
      user: user_name,
      password: password,
      verify_ssl: @verify_cert
    )
  end
  
  def get_auth_token(user_name,password)
    login(user_name,password).headers[:x_sds_auth_token]
  end
  
  def add_host(host)
     JSON.parse(RestClient::Request.execute(method: :post,
       url: "#{base_url}/tenants/#{@tenant_uid}/hosts",
       verify_ssl: @verify_cert,
       payload: host,
       headers: {
         :'X-SDS-AUTH-TOKEN' => @auth_token,
         content_type: 'application/json',
         accept: :json
       }))
  end
  
  def add_initiators(initiators,host_href)
    initiators.each do |initiator|
      RestClient::Request.execute(method: :post,
        url: "#{@base_url}#{host_href}/initiators",
        verify_ssl: @verify_cert,
        payload: initiator,
        headers: {
          :'X-SDS-AUTH-TOKEN' => @auth_token,
          content_type: 'application/json',
          accept: :json
        })
    end
  end
  
  def get_all_hosts
    JSON.parse(RestClient::Request.execute(method: :get,
      url: "#{@base_url}/tenants/#{@tenant_uid}/hosts",
      verify_ssl: @verify_cert,
      headers: {
        :'X-SDS-AUTH-TOKEN' => @auth_token,
        accept: :json
      }))
  end
  
  def get_host(host_href)
    JSON.parse(RestClient::Request.execute(method: :get,
      url: "#{base_url}#{host_href}",
      verify_ssl: @verify_cert,
      headers: {
        :'X-SDS-AUTH-TOKEN' => @auth_token,
        content_type: 'application/json',
        accept: :json
      }))
  end
  
  def deactivate_host(host_href)
    JSON.parse(RestClient::Request.execute(method: :post,
      url: "#{base_url}#{host_href}/deactivate",
      verify_ssl: @verify_cert,
      headers: {
        :'X-SDS-AUTH-TOKEN' => @auth_token,
        content_type: 'application/json',
        accept: :json
      }))
  end

  def add_host_and_initiators(host)
    add_initiators(host.generate_initiators_json,add_host(host.generate_json)['resource']['link']['href'])
  end
  
  def host_exists?(hostname)
    find_host_object(hostname)['resource'].any?
  end
  
  def find_host_object(search_hash)
    JSON.parse(RestClient::Request.execute(method: :get,
      url: "#{@base_url}/compute/hosts/search?name=#{search_hash}",
      verify_ssl: @verify_cert,
      headers: {
        :'X-SDS-AUTH-TOKEN' => @auth_token,
        accept: :json
      }))
  end
  
  def get_all_vcenters
    JSON.parse(RestClient::Request.execute(method: :get,url: "#{@base_url}/compute/vcenters/bulk",
      verify_ssl: @verify_cert,
      headers: {
        :'X-SDS-AUTH-TOKEN' => @auth_token,
        accept: :json
      }))
  end

  def find_vcenter_object(vcenter_search_hash)
    JSON.parse(RestClient::Request.execute(method: :get,
      url: "#{@base_url}/compute/vcenters/search?name=#{vcenter_search_hash}",
      verify_ssl: @verify_cert,
      headers: {
        :'X-SDS-AUTH-TOKEN' => @auth_token,
        accept: :json
      }))
  end
  
  def add_vcenter(fqdn_or_ip, name, port, user_name, password)
    vcenterxml = Nokogiri::XML::Builder.new do |xml|
      xml.vcenter_create {
        xml.ip_address  fqdn_or_ip
        xml.name        name
        xml.port_number port
        xml.user_name   user_name
        xml.password    password
      }
    end

    JSON.parse(RestClient::Request.execute(method: :post,
       url: "#{base_url}/tenants/#{@tenant_uid}/vcenters",
       verify_ssl: @verify_cert,
       payload: vcenterxml.to_xml,
       headers: {
         :'X-SDS-AUTH-TOKEN' => @auth_token,
         content_type: 'application/xml',
         accept: :json
       }))
  end

  def delete_vcenter(vcenter_id)
    JSON.parse(RestClient::Request.execute(method: :post,
       url: "#{base_url}/compute/vcenters/#{vcenter_id}/deactivate",
       verify_ssl: @verify_cert,
       headers: {
         :'X-SDS-AUTH-TOKEN' => @auth_token,
         content_type: 'application/json',
         accept: :json
       }))
  end

  # EMC VMAX and VNX for block storage system version support
  # => For supported versions, see the EMC ViPR Support Matrix on the EMC Community Network (community.emc.com)
  # The EMC SMI-S Provider (a component of EMC Solutions Enabler) is required to use VMAX storage or VNX block. 
  # The following information is required to verify & add the SMI-S provider storage systems to ViPR:
  # => SMI-S Provider host address
  # => SMI-S Provider credentials (default is admin/#1Password) 
  # => SMI-S Provider port (default is 5989)
  def add_emc_block_storage(name, ip_address, port_number, user_name, password, use_ssl)
      emc_block_storage_xml = Nokogiri::XML::Builder.new do |xml|
        xml.storage_provider_create {
          xml.name            name
          xml.interface_type  "smis"
          xml.ip_address      ip_address
          xml.port_number     port_number
          xml.user_name       user_name
          xml.password        password
          xml.use_ssl         use_ssl
        }
      end

      JSON.parse(RestClient::Request.execute(method: :post,
         url: "#{base_url}/vdc/storage-providers",
         verify_ssl: @verify_cert,
         payload: emc_block_storage_xml.to_xml,
         headers: {
           :'X-SDS-AUTH-TOKEN' => @auth_token,
           content_type: 'application/xml',
           accept: :json
         }))
  end

  # EMC VNX for File storage system support
  # => Supported Protocol: NFS, CIFS (Snapshot restore is not supported for Isilon storage systems.)
  # VNX File Control Station default port is 443
  # VNX File Onboard Storage Provider default port is 5988
  def add_emc_vnx_file_storage(name, ip_address, port_number, user_name, password, smis_provider_ip, smis_port_number, smis_user_name, smis_password, smis_use_ssl)
      emc_vnx_file_storage_xml = Nokogiri::XML::Builder.new do |xml|
        xml.storage_system_create {
          xml.name              name
          xml.system_type       "vnxfile"
          xml.ip_address        ip_address
          xml.port_number       port_number
          xml.user_name         user_name
          xml.password          password
          xml.smis_provider_ip  smis_provider_ip
          xml.smis_port_number  smis_port_number
          xml.smis_user_name    smis_user_name
          xml.smis_password     smis_password
          xml.smis_use_ssl      smis_use_ssl
        }
      end

      JSON.parse(RestClient::Request.execute(method: :post,
         url: "#{base_url}/vdc/storage-systems",
         verify_ssl: @verify_cert,
         payload: emc_vnx_file_storage_xml.to_xml,
         headers: {
           :'X-SDS-AUTH-TOKEN' => @auth_token,
           content_type: 'application/xml',
           accept: :json
         }))
  end
  
  # Isilon Storage System Support
  # => Supported Protocol: NFS, CIFS (Snapshot restore is not supported for Isilon storage systems.)
  # Port (default is 8080) 
  def add_emc_isilon_storage(name, ip_address, port_number, user_name, password)
      emc_isilon_storage_xml = Nokogiri::XML::Builder.new do |xml|
        xml.storage_system_create {
          xml.name name
          xml.system_type "isilon"
          xml.ip_address ip_address
          xml.port_number port_number
          xml.user_name user_name
          xml.password password
        }
      end

      JSON.parse(RestClient::Request.execute(method: :post,
         url: "#{base_url}/vdc/storage-systems",
         verify_ssl: @verify_cert,
         payload: emc_isilon_storage_xml.to_xml,
         headers: {
           :'X-SDS-AUTH-TOKEN' => @auth_token,
           content_type: 'application/xml',
           accept: :json
         }))
  end

  # ViPR configuration requirements for VPLEX storage systems
  # ViPR supports VPLEX in a Local or Metro configuration. VPLEX Geo configurations are not supported. 
  def add_emc_vplex_storage(name, ip_address, port_number, user_name, password, use_ssl)
      emc_vplex_storage_xml = Nokogiri::XML::Builder.new do |xml|
        xml.storage_provider_create {
          xml.name name
          xml.interface_type "vplex"
          xml.ip_address ip_address
          xml.port_number port_number
          xml.user_name user_name
          xml.password password
          xml.use_ssl
        }
      end

      JSON.parse(RestClient::Request.execute(method: :post,
         url: "#{base_url}/vdc/storage-providers",
         verify_ssl: @verify_cert,
         payload: emc_vplex_storage_xml.to_xml,
         headers: {
           :'X-SDS-AUTH-TOKEN' => @auth_token,
           content_type: 'application/xml',
           accept: :json
         }))
  end

  # Stand-alone ScaleIO support and preconfiguration requirements
  # Supported versions: ScaleIO 1.21.0.20 or later 
  # Preconfiguration requirements:
  # => Protection domains are defined.
  # => All storage pools are defined. 
  def add_emc_scaleio_storage(name, ip_address, port_number, user_name, password)
      emc_scaleio_storage_xml = Nokogiri::XML::Builder.new do |xml|
        xml.storage_provider_create {
          xml.name name
          xml.interface_type "scaleio"
          xml.ip_address ip_address
          xml.port_number port_number
          xml.user_name user_name
          xml.password password
        }
      end

      JSON.parse(RestClient::Request.execute(method: :post,
         url: "#{base_url}/vdc/storage-providers",
         verify_ssl: @verify_cert,
         payload: emc_scaleio_storage_xml.to_xml,
         headers: {
           :'X-SDS-AUTH-TOKEN' => @auth_token,
           content_type: 'application/xml',
           accept: :json
         }))
  end
  
  # Third-party block storage provider installation requirements
  # ViPR uses the OpenStack Block Storage (Cinder) Service to add third-party block storage systems to ViPR. 
  # For supported versions, see the EMC ViPR Support Matrix available on the EMC Community Network (community.emc.com). 
  def add_third_party_block_storage(name, ip_address, port_number, user_name, password, use_ssl)
      third_party_block_storage_xml = Nokogiri::XML::Builder.new do |xml|
        xml.storage_provider_create {
          xml.name name
          xml.interface_type "cinder"
          xml.ip_address ip_address
          xml.port_number port_number
          xml.user_name user_name
          xml.password password
          xml.use_ssl use_ssl
        }
      end

      JSON.parse(RestClient::Request.execute(method: :post,
         url: "#{base_url}/vdc/storage-providers",
         verify_ssl: @verify_cert,
         payload: third_party_block_storage_xml.to_xml,
         headers: {
           :'X-SDS-AUTH-TOKEN' => @auth_token,
           content_type: 'application/xml',
           accept: :json
         }))
  end
  
  # NetApp Storage System Support
  # => Supported Protocol: NFS, CIFS
  def add_netapp_storage(name, ip_address, port_number, user_name, password)
      netapp_storage_xml = Nokogiri::XML::Builder.new do |xml|
        xml.storage_system_create {
          xml.name name
          xml.system_type "netapp"
          xml.ip_address ip_address
          xml.port_number port_number
          xml.user_name user_name
          xml.password password
        }
      end

      JSON.parse(RestClient::Request.execute(method: :post,
         url: "#{base_url}/vdc/storage-systems",
         verify_ssl: @verify_cert,
         payload: netapp_storage_xml.to_xml,
         headers: {
           :'X-SDS-AUTH-TOKEN' => @auth_token,
           content_type: 'application/xml',
           accept: :json
         }))
  end

  # Hitachi Data Systems support
  # For supported versions, see the EMC ViPR Support Matrix on the EMC Community Network (community.emc.com).
  # Hitachi HiCommand Device Manager is required to use HDS storage with ViPR. 
  # You need to obtain the following information to configure and add the Hitachi HiCommand Device manager to ViPR:
  # => A host or virtual machine for HiCommand Device manager setup
  # => HiCommand Device Manager license, host address, credentials, and host port (default is 2001)  
  def add_hitachi_storage(name, ip_address, port_number, user_name, password, use_ssl)
      hitachi_storage_xml = Nokogiri::XML::Builder.new do |xml|
        xml.storage_provider_create {
          xml.name name
          xml.interface_type "hicommand"
          xml.ip_address ip_address
          xml.port_number port_number
          xml.user_name user_name
          xml.password password
          xml.use_ssl use_ssl
        }
      end

      JSON.parse(RestClient::Request.execute(method: :post,
         url: "#{base_url}/vdc/storage-providers",
         verify_ssl: @verify_cert,
         payload: hitachi_storage_xml.to_xml,
         headers: {
           :'X-SDS-AUTH-TOKEN' => @auth_token,
           content_type: 'application/xml',
           accept: :json
         }))
  end  

  def to_boolean(str)
    str.to_s.downcase == "true"
  end
  
  private :login, :get_auth_token, :get_tenant_uid, :to_boolean
end

class Host
  attr_accessor :fqdn, :ip_address, :type, :name, :discoverable, :initiators_port, :initiator_node, :protocol
  
  def initialize params = {}
    params.each { |key, value| send "#{key}=", value }
  end
  
  def generate_json
    {
      type: @type.capitalize,
      name: @name,
      host_name: @fqdn,
      discoverable: @discoverable.downcase
    }.to_json
  end
  
  def generate_initiators_json
    initiator_json = []
    @initiators_port.each do |initiator|
      initiator_json <<
      {
        protocol: @protocol.upcase,
        initiator_port: initiator,
        initiator_node: @initiator_node
      }.to_json
    end
    initiator_json
  end
  
end