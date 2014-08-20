require 'rest-client'
require 'json'

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