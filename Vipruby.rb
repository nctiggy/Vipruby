require 'rest_client'
require 'json'

class Vipruby
  attr_accessor :tenant_uid, :auth_token, :base_url
  SSL_VERSION = 'TLSv1'
  
  def initialize(base_url,user_name,password)
    #add condition later for trusted certs (This ignores)
    #OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    @base_url = base_url
    @auth_token = get_auth_token(user_name,password)
    @tenant_uid = get_tenant_uid['id']
  end
  
  def get_tenant_uid
    JSON.parse(RestClient::Request.execute(method: :get,url: "#{base_url}/tenant",
      headers: {:'X-SDS-AUTH-TOKEN' => @auth_token,
        accept: :json
      },
      ssl_version: SSL_VERSION
      ))
  end
  
  def login(user_name,password)
    RestClient::Request.execute(method: :get,url: "#{base_url}/login", user: user_name, password: password,ssl_version: SSL_VERSION)
  end
  
  def get_auth_token(user_name,password)
    login(user_name,password).headers[:x_sds_auth_token]
  end
  
  def add_host(host)
     RestClient::Request.execute(method: :post,
       url: "#{base_url}/tenants/#{@tenant_uid}/hosts",
       ssl_version: SSL_VERSION,
       payload: host,
       headers: {
         :'X-SDS-AUTH-TOKEN' => @auth_token,
         content_type: 'application/json',
         accept: :json
       })
  end
  
  def add_initiators(initiators,host_href)
    initiators.each do |initiator|
      RestClient::Request.execute(method: :post,
        url: "#{base_url}#{host_href}/initiators",
        ssl_version: SSL_VERSION,
        payload: initiator,
        headers: {
          :'X-SDS-AUTH-TOKEN' => @auth_token,
          content_type: 'application/json',
          accept: :json
        })
    end
  end
  
  def get_hosts
    RestClient::Request.execute(method: :get,url: "#{base_url}/tenants/#{@tenant_uid}/hosts",
      ssl_version: SSL_VERSION,
      headers: {
        :'X-SDS-AUTH-TOKEN' => @auth_token,
        accept: :json
      })
  end
  
  def add_host_and_initiators(host)
    new_host = JSON.parse(add_host(host.generate_json))
    add_initiators(host.generate_initiators_json,new_host['resource']['link']['href'])
  end
  
  def host_exists?(hostname)
    JSON.parse(find_vipr_object(hostname))['resource'].any?
  end
  
  def find_vipr_object(search_hash)
    RestClient::Request.execute(method: :get,
      url: "#{base_url}/compute/hosts/search?name=#{search_hash}",
      ssl_version: SSL_VERSION,
      headers: {
        :'X-SDS-AUTH-TOKEN' => @auth_token,
        accept: :json
      })
  end
  
  private :login, :get_auth_token, :get_tenant_uid
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