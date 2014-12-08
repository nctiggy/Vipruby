require 'rest-client'
require 'json'

module ViprBase
  
  # Generic API post call
  #
  # @param payload [JSON] the JSON payload to be posted
  # @param api_url [string] the full API URL path
  # @return [JSON] the object converted into JSON format.
  def rest_post(payload, api_url, auth=nil, cert=nil)
    JSON.parse(RestClient::Request.execute(method: :post,
         url: api_url,
         verify_ssl: cert.nil? ? @verify_cert : cert,
         payload: payload,
         headers: {
           :'X-SDS-AUTH-TOKEN' => auth.nil? ? @auth_token : auth,
           content_type: 'application/json',
           accept: :json
         }))
  end

  # Generic API get call
  #
  # @param api_url [string] the full API URL path
  # @return [JSON] the object converted into JSON format.
  def rest_get(api_url, auth=nil, cert=nil)
    JSON.parse(RestClient::Request.execute(method: :get,
      url: api_url,
      verify_ssl: cert.nil? ? @verify_cert : cert,
      headers: {
        :'X-SDS-AUTH-TOKEN' => auth.nil? ? @auth_token : auth,
        accept: :json
      }))
  end
  
  # Get the current users Tenant UID
  #
  # @return [array] HTML return with the Tenant UID ['id].
  def get_tenant_uid(base=nil, auth=nil, cert=nil)
    rest_get(base.nil? ? @base_url + "/tenant" : base + "/tenant", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end
  
  # Login to ViPR
  #
  # @param user_name [string] the username used to login
  # @param password [string] the password for the username
  # @return [HTML] returns token information in headers
  def login(user_name, password, cert=nil, base=nil)
    RestClient::Request.execute(method: :get,
      url: base.nil? ? @base_url : base + "/login",
      user: user_name,
      password: password,
      verify_ssl: cert.nil? ? @verify_cert : cert
    )
  end
  
  def generate_base_url(ip_or_fqdn)
    "https://#{ip_or_fqdn}:4443"
  end
  
  # Get User's Authentication Token
  #
  # @param user_name [string] the username used to login
  # @param password [string] the password for the username
  # @return [String] returns authentication token for the user
  def get_auth_token(user_name,password, cert=nil, base=nil)
    login(user_name, password, cert.nil? ? @verify_cert : cert, base.nil? ? @base_url : base).headers[:x_sds_auth_token]
  end
  
  # Ensure value is a boolean
  #
  # @param str [string, bool] the value to convert or verify
  # @return [bool] returns True or False
  def to_boolean(str)
    str.to_s.downcase == "true"
  end

end