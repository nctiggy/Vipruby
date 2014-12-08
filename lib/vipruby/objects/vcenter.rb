require 'rest-client'
require 'json'

module ViprVcenter

  ####################################################################
  # The Following vCenter calls will get vCenter information 
  # for all tenants. these commands can only be ran as the root/default tenant
  ####################################################################
  def get_all_vcenters(auth=nil, cert=nil)
    rest_get("#{@base_url}/compute/vcenters/bulk", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end

  def get_vcenter(vcenter_id=nil, auth=nil, cert=nil)
    check_vcenter(vcenter_id)
    rest_get("#{@base_url}/compute/vcenters/#{vcenter_id}", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end

  def get_vcenter_hosts(vcenter_id=nil, auth=nil, cert=nil)
    check_vcenter(vcenter_id)
    rest_get("#{@base_url}/compute/vcenters/#{vcenter_id}/hosts", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end

  def get_vcenter_clusters(vcenter_id=nil, auth=nil, cert=nil)
    check_vcenter(vcenter_id)
    rest_get("#{@base_url}/compute/vcenters/#{vcenter_id}/clusters", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end

  def get_vcenter_datacenters(vcenter_id=nil, auth=nil, cert=nil)
    check_vcenter(vcenter_id)
    rest_get("#{@base_url}/compute/vcenters/#{vcenter_id}/vcenter-data-centers", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end

  def find_vcenter_object(vcenter_search_hash=nil, auth=nil, cert=nil)
    check_vcenter_object_hash(vcenter_search_hash)
    rest_get("#{@base_url}/compute/vcenters/search?name=#{vcenter_search_hash}", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end

  def add_vcenter(fqdn_or_ip=nil, name=nil, port=nil, user_name=nil, password=nil, tenant=nil, auth=nil, cert=nil)
    check_vcenter_post(fqdn_or_ip, name, port, user_name, password)
    payload = {
        ip_address: fqdn_or_ip,
        name: name,
        port_number: port,
        user_name: user_name,
        password: password
      }.to_json
    rest_post(payload, "#{base_url}/tenants/#{@tenant_uid}/vcenters", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end

  def delete_vcenter(vcenter_id=nil, auth=nil, cert=nil)
    check_vcenter(vcenter_id)
    payload = {
      }.to_json
    rest_post(payload, "#{base_url}/compute/vcenters/#{vcenter_id}/deactivate", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end

  #############################################################
  # Error Handling method to make sure params are there
  ##############################################################
  def check_vcenter(vcenter_id=nil)
    if vcenter_id == nil
        raise "Missing vCenter ID param (vcenter_id)"
    end
  end

  def check_vcenter_object_hash(vcenter_search_hash=nil)
    if vcenter_search_hash == nil
        raise "Missing vCenter Object to search as a param"
    end
  end

  def check_vcenter_post(fqdn_or_ip=nil, name=nil, port=nil, user_name=nil, password=nil)
    if fqdn_or_ip == nil || name == nil || port == nil || user_name == nil || password == nil
      raise "Missing a Required Param of fqdn_or_ip, name, port, user_name, or password"
    end
  end

end