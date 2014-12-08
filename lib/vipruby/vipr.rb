
require "vipruby/viprbase"
require "vipruby/objects/vcenter"
require 'vipruby/objects/storagesystem'

class Vipr
  include ViprBase
  include ViprVcenter
  include ViprStorageSystem

  attr_accessor :tenant_uid, :auth_token, :base_url, :verify_cert
  #SSL_VERSION = 'TLSv1'
  
  def initialize(base_url,user_name,password,verify_cert)
    @base_url = base_url
    @verify_cert = to_boolean(verify_cert)
    @auth_token = get_auth_token(user_name,password)
    
    #Every POST call requires a Tenant UID to place a the object.
    #This variable gets the current logged in tenant information.
    #Nothing else needs to be done if there is a single tenant configured for ViPR
    #If resources need to be added to specific tenants, this variable must be overwritten
    @tenant_uid = get_tenant_uid['id']
  end
  
  # Add a host to ViPR
  #
  # @param host_payload [JSON] New host information
  # @return [JSON] returns host information
  def add_host(host_payload, auth=nil, cert=nil)
    rest_post(host_payload, "#{base_url}/tenants/#{@tenant_uid}/hosts", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end
  
  # Add an initiator to a host in ViPR
  #
  # @param initiator_payload [JSON] New initiator information in JSON format
  # @param host_href [STRING] HREF value of a host
  # @return [JSON] returns initiator information
  def add_initiator(initiator_payload,host_href, auth=nil, cert=nil)
    rest_post(initiator_payload, "#{@base_url}#{host_href}/initiators", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end
  
  # Get all Host objects in ViPR
  #
  # @return [JSON] returns a JSON collection of all hosts in ViPR
  def get_all_hosts(auth=nil, cert=nil)
    rest_get("#{@base_url}/tenants/#{@tenant_uid}/hosts", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end
  
  # Get an individual host's details in ViPR
  #
  # @param host_href [STRING] HREF value of a host
  # @return [JSON] returns host information
  def get_host(host_href, auth=nil, cert=nil)
    rest_get("#{base_url}#{host_href}", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end
  
  # Deactive a host
  #
  # @param host_href [STRING] HREF value of a host
  # @return [JSON] returns ... information
  def deactivate_host(host_href, auth=nil, cert=nil)
    rest_post(nil, "#{base_url}#{host_href}/deactivate", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end

  # Add a host and it's initiators (Need to change param values)
  #
  # @param host [OBJECT] host object
  # @return [JSON] returns host information
  # @author Craig J Smith
  #def add_host_and_initiators(host)
  #  host_href = add_host(host.generate_json)['resource']['link']['href']
  #  host.generate_inistiators_json.each do |initiator|
  #    add_initiator(initiator,host_href)
  #  end
  #end
  
  # Detirmine if a host already exists in ViPR
  #
  # @param hostname [STRING] The name of the host to search for
  # @return [BOOLEAN] returns TRUE/FALSE 
  def host_exists?(hostname, auth=nil, cert=nil)
    find_host_object(hostname)['resource'].any?
  end
  
  # Find and return query results for a host in ViPR
  #
  # @param search_param [STRING] Value to search host for
  # @return [JSON] returns search results
  def find_host_object(search_param, auth=nil, cert=nil)
    rest_get("#{@base_url}/compute/hosts/search?name=#{search_param}", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end

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