require 'rest-client'
require 'json'
require 'vipruby/viprbase'
require 'vipruby/objects/vcenter'
require 'vipruby/objects/emc_block'
require 'vipruby/objects/emc_file'
require 'vipruby/objects/isilon'
require 'vipruby/objects/scaleio'
require 'vipruby/objects/thirdpartyblock'
require 'vipruby/objects/netapp'
require 'vipruby/objects/hitachi'

class Vipruby
  include 'ViprBase'
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

  #############################################################
  # The Following are all a bunch of vCenter calls
  #
  ##############################################################
  def add_vcenter(fqdn_or_ip, name, port, user_name, password)
    api_url = "#{base_url}/tenants/#{@tenant_uid}/vcenters"
    Vcenter.new(fqdn_or_ip, name, port, user_name, password, api_url, @verify_cert, @auth_token).add
  end

  def get_all_vcenters
    api_url = "#{@base_url}/compute/vcenters/bulk"
    RestCall.rest_get(api_url, @verify_cert, @auth_token)
  end

  def get_vcenter(vcenter_id)
    api_url = "#{@base_url}/compute/vcenters/#{vcenter_id}"
    RestCall.rest_get(api_url, @verify_cert, @auth_token)
  end

  def get_vcenter_hosts(vcenter_id)
    api_url = "#{@base_url}/compute/vcenters/#{vcenter_id}/hosts"
    RestCall.rest_get(api_url, @verify_cert, @auth_token)
  end

  def get_vcenter_clusters(vcenter_id)
    api_url = "#{@base_url}/compute/vcenters/#{vcenter_id}/clusters"
    RestCall.rest_get(api_url, @verify_cert, @auth_token)
  end

  def get_vcenter_datacenters(vcenter_id)
    api_url = "#{@base_url}/compute/vcenters/#{vcenter_id}/vcenter-data-centers"
    RestCall.rest_get(api_url, @verify_cert, @auth_token)
  end

  ###This call adds a datacenter to ViPR, but DOES NOT add it to the actual vCenter
  ###for some reason. When you perform a vCenter "rediscover", the new datacenter
  ###is no longer there. Don't know..?
  def add_vcenter_datacenter(vcenter_id, name)
    api_url = "#{@base_url}/compute/vcenters/#{vcenter_id}/vcenter-data-centers"
    Vcenter.add_datacenter(name, api_url, @verify_cert, @auth_token)
  end

  def find_vcenter_object(vcenter_search_hash)
    api_url = "#{@base_url}/compute/vcenters/search?name=#{vcenter_search_hash}"
    puts "this far"
    RestCall.rest_get(api_url, @verify_cert, @auth_token)
  end

  def delete_vcenter(vcenter_id)
    api_url = "#{base_url}/compute/vcenters/#{vcenter_id}/deactivate"
    Vcenter.delete(api_url, @verify_cert, @auth_token)
    #### Or we can call the RestClass directly since we don't
    #### don't need to reference a ruby object
    # payload = {
    # }.to_json
    # RestCall.rest_post(payload, api_url, @verify_cert, @auth_token)
    ####
  end

  ##---------- ADD STORAGE ARRAYS --------------##

  # EMC VMAX and VNX for block storage system version support
  # => For supported versions, see the EMC ViPR Support Matrix on the EMC Community Network (community.emc.com)
  # The EMC SMI-S Provider (a component of EMC Solutions Enabler) is required to use VMAX storage or VNX block. 
  # The following information is required to verify & add the SMI-S provider storage systems to ViPR:
  # => SMI-S Provider host address
  # => SMI-S Provider credentials (default is admin/#1Password) 
  # => SMI-S Provider port (default is 5989)
  def add_emc_block(name, ip_address, port, user_name, password, use_ssl)
      api_url = "#{base_url}/vdc/storage-providers"
      EMCblock.new(name, ip_address, port, user_name, password, use_ssl, api_url, @verify_cert, @auth_token).add
  end

  # EMC VNX for File storage system support
  # => Supported Protocol: NFS, CIFS (Snapshot restore is not supported for Isilon storage systems.)
  # VNX File Control Station default port is 443
  # VNX File Onboard Storage Provider default port is 5988
  def add_emc_file(name, ip_address, port, user_name, password, smis_provider_ip, smis_port_number, smis_user_name, smis_password, smis_use_ssl)
      api_url = "#{base_url}/vdc/storage-systems"
      EMCfile.new(name, ip_address, port, user_name, password, smis_provider_ip, smis_port_number, smis_user_name, smis_password, smis_use_ssl, api_url, @verify_cert, @auth_token).add
  end
  
  # Isilon Storage System Support
  # => Supported Protocol: NFS, CIFS (Snapshot restore is not supported for Isilon storage systems.)
  # Port (default is 8080) 
  def add_isilon(name, ip_address, port, user_name, password)
      api_url = "#{base_url}/vdc/storage-systems"
      Isilon.new(name, ip_address, port, user_name, password, api_url, @verify_cert, @auth_token).add
  end

  # ViPR configuration requirements for VPLEX storage systems
  # ViPR supports VPLEX in a Local or Metro configuration. VPLEX Geo configurations are not supported. 
  def add_vplex(name, ip_address, port, user_name, password, use_ssl)
      api_url = "#{base_url}/vdc/storage-providers"
      Vplex.new(name, ip_address, port, user_name, password, use_ssl, api_url, @verify_cert, @auth_token).add
  end

  # Stand-alone ScaleIO support and preconfiguration requirements
  # Supported versions: ScaleIO 1.21.0.20 or later 
  # Preconfiguration requirements:
  # => Protection domains are defined.
  # => All storage pools are defined. 
  def add_scaleio(name, ip_address, port, user_name, password)
      api_url = "#{base_url}/vdc/storage-providers"
      Isilon.new(name, ip_address, port, user_name, password, api_url, @verify_cert, @auth_token).add
  end
  
  # Third-party block storage provider installation requirements
  # ViPR uses the OpenStack Block Storage (Cinder) Service to add third-party block storage systems to ViPR. 
  # For supported versions, see the EMC ViPR Support Matrix available on the EMC Community Network (community.emc.com). 
  def add_third_party_block(name, ip_address, port, user_name, password, use_ssl)
      api_url = "#{base_url}/vdc/storage-providers"
      ThirdPartyBlock.new(name, ip_address, port, user_name, password, use_ssl, api_url, @verify_cert, @auth_token).add
  end
  
  # NetApp Storage System Support
  # => Supported Protocol: NFS, CIFS
  def add_netapp(name, ip_address, port, user_name, password)
      api_url = "#{base_url}/vdc/storage-systems"
      Netapp.new(name, ip_address, port, user_name, password, api_url, @verify_cert, @auth_token).add
  end

  # Hitachi Data Systems support
  # For supported versions, see the EMC ViPR Support Matrix on the EMC Community Network (community.emc.com).
  # Hitachi HiCommand Device Manager is required to use HDS storage with ViPR. 
  # You need to obtain the following information to configure and add the Hitachi HiCommand Device manager to ViPR:
  # => A host or virtual machine for HiCommand Device manager setup
  # => HiCommand Device Manager license, host address, credentials, and host port (default is 2001)  
  def add_hitachi(name, ip_address, port, user_name, password, use_ssl)
      api_url = "#{base_url}/vdc/storage-providers"
      Hitachi.new(name, ip_address, port, user_name, password, use_ssl, api_url, @verify_cert, @auth_token).add
  end  

####----------- END STORAGE ARRAYS ----------------######

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