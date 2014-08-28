require 'rest-client'
require 'json'

module ViprBase
  
  # Generic API post call
  #
  # @param payload [JSON] the JSON payload to be posted
  # @param api_url [string] the full API URL path
  # @return [JSON] the object converted into JSON format.
  # @author Kendrick Coleman
  def rest_post(payload, api_url)
    JSON.parse(RestClient::Request.execute(method: :post,
         url: api_url,
         verify_ssl: @verify_cert,
         payload: payload,
         headers: {
           :'X-SDS-AUTH-TOKEN' => @auth_token,
           content_type: 'application/json',
           accept: :json
         })).to_json
  end

  # Generic API get call
  #
  # @param api_url [string] the full API URL path
  # @return [JSON] the object converted into JSON format.
  # @author Kendrick Coleman
  def rest_get(api_url)
    JSON.parse(RestClient::Request.execute(method: :get,
      url: api_url,
      verify_ssl: @verify_cert,
      headers: {
        :'X-SDS-AUTH-TOKEN' => @auth_token,
        accept: :json
      })).to_json
  end
  
  # Get the users Tenant UID
  #
  # @return [array] HTML return with the Tenant UID ['id].
  # @author Craig J Smith
  def get_tenant_uid
    JSON.parse(RestClient::Request.execute(method: :get,
      url: "#{@base_url}/tenant",
      headers: {:'X-SDS-AUTH-TOKEN' => @auth_token,
        accept: :json
      },
      verify_ssl: @verify_cert
      ))
  end
  
  # Login to ViPR
  #
  # @param user_name [string] the username used to login
  # @param password [string] the password for the username
  # @return [HTML] returns token information in headers
  # @author Craig J Smith
  def login(user_name,password)
    RestClient::Request.execute(method: :get,
      url: "#{@base_url}/login",
      user: user_name,
      password: password,
      verify_ssl: @verify_cert
    )
  end
  
  # Get User's Authentication Token
  #
  # @param user_name [string] the username used to login
  # @param password [string] the password for the username
  # @return [String] returns authentication token for the user
  # @author Craig J Smith
  def get_auth_token(user_name,password)
    login(user_name,password).headers[:x_sds_auth_token]
  end
  
  # Ensure value is a boolean
  #
  # @param str [string, bool] the value to convert or verify
  # @return [bool] returns True or False
  # @author Craig J Smith
  def to_boolean(str)
    str.to_s.downcase == "true"
  end
  
  private :login, :get_auth_token, :get_tenant_uid, :to_boolean, :rest_post, :rest_get
end