module Vipruby
  class Auth
    attr_reader :base_url, :verify_cert, :user_name, :password
    
    def self.get_auth_token (args, & block)
      new(args).get_auth_token(& block)
    end
    
    def initialize args
      @base_url = args[:base_url] or raise ArgumentError, "must pass :base_url"
      @verify_cert = args[:verify_cert] or raise ArgumentError, "must pass :verify_cert"
      @user_name = args[:user_name] or raise ArgumentError, "must pass :user_name"
      @password = args[:password] or raise ArgumentError, "must pass :password"
    end
    
    def login
      RestClient::Request.execute(method: :get,
        url: @base_url,
        user: @user_name,
        password: @password,
        verify_ssl: @verify_cert
      )
    end
    
    def get_auth_token
      login.headers[:x_sds_auth_token]
    end
    
    def generate_base_url(ip_or_fqdn)
      "https://#{ip_or_fqdn}:4443"
    end
    
  end
end