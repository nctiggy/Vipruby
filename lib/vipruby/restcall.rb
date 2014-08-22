require 'rest-client'
require 'json'

class RestCall
  def RestCall.rest_post (payload, api_url, verify_cert, auth_token)
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

  def RestCall.rest_get (api_url, verify_cert, auth_token)
    JSON.parse(RestClient::Request.execute(method: :get,
      url: api_url,
      verify_ssl: verify_cert,
      headers: {
        :'X-SDS-AUTH-TOKEN' => auth_token,
        accept: :json
      }))
  end
end