
require "vipruby/viprbase"
require "vipruby/objects/vcenter"
require 'vipruby/objects/storagesystem'
require 'vipruby/objects/host'

# The base class for the gem. Every subsequent method relies on creating an object from this class
class Vipr
  include ViprBase
  include ViprVcenter
  include ViprStorageSystem
  include ViprHost

  # required params used for almost every single method
  attr_accessor :tenant_uid, :auth_token, :base_url, :verify_cert
  
  # Initializes a Vipr object that all methods can follow.
  #
  # @param base_url [String] The IP address or FQDN of the ViPR appliance. Do not include 'https' or port numbers
  # @param user_name [String] Username used to log into ViPR
  # @param password [String] Password used to log into ViPR
  # @param verify_cert [Boolean] Should the cert be SSL verified? Setting it to false will work for development purposes. Should be set to true for production
  # @return [Object] The Vipruby object that can be used with many different methods
  #
  # @note 
  #   Every POST call requires a Tenant UID to create an object.
  #   This variable gets the current logged in tenant information.
  #   Nothing else needs to be done if there is a single tenant configured for ViPR
  #   If resources need to be added to specific tenants, this variable must be overwritten
  #   by specifying the tenant_uid
  #
  # @example New Vipruby Object
  #   base_url = 'vipr.mydomain.com'
  #   user_name = 'root'
  #   password = 'mypw'
  #   verify_cert = false
  #   vipr = Vipr.new(base_url,user_name,password,verify_cert)
  def initialize(base_url,user_name,password,verify_cert)
    @base_url = generate_base_url(base_url)
    @verify_cert = to_boolean(verify_cert)
    @auth_token = get_auth_token(user_name,password)
    @tenant_uid = get_tenant_uid['id']
  end

end