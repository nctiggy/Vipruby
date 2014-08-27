require 'rest-client'
require 'json'

module ViprBase
  def rest_post (payload, api_url, verify_cert, auth_token)
    JSON.parse(RestClient::Request.execute(method: :post,
         url: api_url,
         verify_ssl: verify_cert,
         payload: payload,
         headers: {
           :'X-SDS-AUTH-TOKEN' => auth_token,
           content_type: 'application/json',
           accept: :json
         }))
  end

  def rest_get (api_url, verify_cert, auth_token)
    JSON.parse(RestClient::Request.execute(method: :get,
      url: api_url,
      verify_ssl: verify_cert,
      headers: {
        :'X-SDS-AUTH-TOKEN' => auth_token,
        accept: :json
      }))
  end
  
  def generate_json
    
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
  
end