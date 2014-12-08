
require "vipruby/viprbase"
require "vipruby/objects/vcenter"
require 'vipruby/objects/storagesystem'
require 'vipruby/objects/host'

class Vipr
  include ViprBase
  include ViprVcenter
  include ViprStorageSystem
  include ViprHost

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

end