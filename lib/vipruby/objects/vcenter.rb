require 'rest-client'
require 'json'

# The Following vCenter calls will get vCenter information for all tenants
module ViprVcenter
  
  # Retrive all vCenter Servers registered for all tenants
  #
  # @return [Hash] the object converted into Hash format and can be parsed with object[0] or object['id'] notation
  def get_all_vcenters(auth=nil, cert=nil)
    rest_get("#{@base_url}/compute/vcenters/bulk", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end

  # Retrieve information for a single vCenter server using the uid
  #
  # @param vcenter_id [String] Requires the string of the vcenter uid
  # @return [Hash] the object converted into Hash format and can be parsed with object[0] or object['id'] notation
  #
  # @example
  #   x = vipr.get_all_vcenters['id'][0]
  #   vipr.get_vcenter(x)
  def get_vcenter(vcenter_id=nil, auth=nil, cert=nil)
    check_vcenter(vcenter_id)
    rest_get("#{@base_url}/compute/vcenters/#{vcenter_id}", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end

  # Retrieve Host information for a single vCenter server using the uid
  #
  # @param vcenter_id [String] Requires the string of the vcenter uid
  # @return [Hash] the object converted into Hash format and can be parsed with object[0] or object['id'] notation
  #
  # @example
  #   x = vipr.get_all_vcenters['id'][0]
  #   vipr.get_vcenter_hosts(x)
  def get_vcenter_hosts(vcenter_id=nil, auth=nil, cert=nil)
    check_vcenter(vcenter_id)
    rest_get("#{@base_url}/compute/vcenters/#{vcenter_id}/hosts", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end

  # Retrieve Cluster information for a single vCenter server using the uid
  #
  # @param vcenter_id [String] Requires the string of the vcenter uid
  # @return [Hash] the object converted into Hash format and can be parsed with object[0] or object['id'] notation
  #
  # @example
  #   x = vipr.get_all_vcenters['id'][0]
  #   vipr.get_vcenter_clusters(x)
  def get_vcenter_clusters(vcenter_id=nil, auth=nil, cert=nil)
    check_vcenter(vcenter_id)
    rest_get("#{@base_url}/compute/vcenters/#{vcenter_id}/clusters", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end

  # Retrieve Datacenter information for a single vCenter server using the uid
  #
  # @param vcenter_id [String] Requires the string of the vcenter uid
  # @return [Hash] the object converted into Hash format and can be parsed with object[0] or object['id'] notation
  #
  # @example
  #   x = vipr.get_all_vcenters['id'][0]
  #   vipr.get_vcenter_datacenters(x)
  def get_vcenter_datacenters(vcenter_id=nil, auth=nil, cert=nil)
    check_vcenter(vcenter_id)
    rest_get("#{@base_url}/compute/vcenters/#{vcenter_id}/vcenter-data-centers", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end

  # Search for vCenters matching a specific parameter
  #
  # @param vcenter_search_hash [String] String for searching
  # @return [Hash] Will return any vCenter objects containing the search string. The object converted into Hash format and can be parsed with object[0] or object['id'] notation
  #
  # @example
  #   vipr.find_vcenter_object('demo')
  def find_vcenter_object(vcenter_search_hash=nil, auth=nil, cert=nil)
    check_vcenter_object_hash(vcenter_search_hash)
    rest_get("#{@base_url}/compute/vcenters/search?name=#{vcenter_search_hash}", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end

  # Add a vCenters to a specified tenant
  #
  # @param fqdn_or_ip [String] FQDN or IP Address of the vCenter server to add. This is a required string.
  # @param name [String] Name of the vCenter server. This name is arbitrary and only exists within ViPR. This is a required string.
  # @param user_name [String] User Name that will be used for authenticating against the vCenter Server. This is a required string.
  # @param password [String] Password for the user_name that will be used for authenticating against the vCenter Server. This is a required string.
  # @param port [String] Port of the vCenter server. This is an optional parameter. If no parameter is present, the default port of '443' will be used. If registering to a different tenant than default, set this param to nil
  # @param tenant [String] Specify a tenant_uid where the vCenter will be registered. By default it will be added to the tenant of the current logged in ViPR user. This string is optional.
  # @return [Hash] The resulted post operation
  #
  # @example
  #   vipr.add_vcenter('vcenter1.mydomain.com', 'vCENTER1', 'DOMAIN\user', 'userpw')
  #   vipr.add_vcenter('vcenter2.mydomain.com', 'vCENTER2', 'DOMAIN\user', 'userpw', '1092')
  #   vipr.add_vcenter('vcenter3.mydomain.com', 'vCENTER3', 'DOMAIN\user', 'userpw', nil, 'diff_tenant_uid')
  def add_vcenter(fqdn_or_ip=nil, name=nil, user_name=nil, password=nil, port=nil, tenant=nil, auth=nil, cert=nil)
    check_vcenter_post(fqdn_or_ip, name, user_name, password)
    port.nil? ? port = '443' : port = port
    payload = {
        ip_address: fqdn_or_ip,
        name: name,
        port_number: port,
        user_name: user_name,
        password: password
      }.to_json
    rest_post(payload, "#{@base_url}/tenants/#{@tenant_uid}/vcenters", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end

  # Delete a vCenter from any tenant based on vCenter ID
  #
  # @param vcenter_id [String] Requires the string of the vcenter uid
  # @return [Hash] The resulted post operation
  #
  # @example
  #   x = vipr.get_all_vcenters['id'][0]
  #   vipr.delete_vcenter(x)
  def delete_vcenter(vcenter_id=nil, auth=nil, cert=nil)
    check_vcenter(vcenter_id)
    payload = {
      }.to_json
    rest_post(payload, "#{@base_url}/compute/vcenters/#{vcenter_id}/deactivate", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
  end


  private 

  # Error Handling method to check for Missing vCenter ID param. If the pass fails, an error exception is raised
  #
  # @param vcenter_id [String] Requires the string of the vcenter uid
  # @return [Boolean] True if pass, false if it fails
  #
  # @private
  def check_vcenter(vcenter_id=nil)
    if vcenter_id == nil
        raise "Missing vCenter ID param (vcenter_id)"
    end
  end

  # Error Handling method to check for Missing vCenter Object param. If the pass fails, an error exception is raised
  #
  # @param vcenter_search_hash [String] Requires the string of something to search
  # @return [Boolean] True if pass, false if it fails
  #
  # @private
  def check_vcenter_object_hash(vcenter_search_hash=nil)
    if vcenter_search_hash == nil
        raise "Missing vCenter Object to search as a param"
    end
  end

  # Error Handling method to check for Missing Param. If the pass fails, an error exception is raised
  #
  # @param fqdn_or_ip [String] Requires the string of the vcenter FQDN or IP Address
  # @param name [String] Requires the name of the vCenter
  # @param user_name [String] Requires the User Name used for authentication to vCenter
  # @param password [String] Requires the password of the User Name used for authentication to vCenter
  # @return [Boolean] True if pass, false if it fails
  #
  # @private
  def check_vcenter_post(fqdn_or_ip=nil, name=nil, user_name=nil, password=nil)
    if fqdn_or_ip == nil || name == nil || user_name == nil || password == nil
      raise "Missing a Required Param of fqdn_or_ip, name, port, user_name, or password"
    end
  end

end