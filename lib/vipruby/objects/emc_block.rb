  # EMC VMAX and VNX for block storage system version support
  # => For supported versions, see the EMC ViPR Support Matrix on the EMC Community Network (community.emc.com)
  # The EMC SMI-S Provider (a component of EMC Solutions Enabler) is required to use VMAX storage or VNX block. 
  # The following information is required to verify & add the SMI-S provider storage systems to ViPR:
  # => SMI-S Provider host address
  # => SMI-S Provider credentials (default is admin/#1Password) 
  # => SMI-S Provider port (default is 5989)
module EMCblock

  # Adds an EMC block device to ViPR
  # => SMI-S Provider host address
  # => SMI-S Provider credentials (default is admin/#1Password) 
  # => SMI-S Provider port (default is 5989)
  #
  # @param name [String] the name of the device
  # @param ip_address [string] the ip address of the device
  # @return [JSON] the object converted into the expected format.
  # @author Kendrick Coleman
  def add_emc_block_device (name, ip_address, port, user_name, password, use_ssl, api_url, verify_cert, auth_token)
    payload = {
      name: name,
      interface_type:  interface_type,
      ip_address: ip_address,
      port_number: port,
      user_name: user_name,
      password: password,
      use_ssl: use_ssl
    }
    
    RestCall.rest_post(payload, api_url, verify_cert, auth_token)
  end

end 
