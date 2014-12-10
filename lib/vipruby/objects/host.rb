require 'rest-client'
require 'json'

module ViprHost

    def generate_host_post_json(host_type, ip_or_dns, name, port, user_name, password, use_ssl, discoverable)
        payload = {
            type: host_type,
            host_name: ip_or_dns,
            name: name,
            port_number: port,
            user_name: user_name,
            password: password,
            use_ssl: use_ssl,
            discoverable: discoverable
        }.to_json

        return payload
    end
      
    def generate_initiators_json(protocol, initiator_node, initiator_port)
        initiator_json = []
        initiator_port.each do |initiator|
            initiator_json << 
            {
                protocol: protocol,
                initiator_node: initiator_node,
                initiator_port: initiator
            }.to_json
        end
        return initiator_json
    end
    # Add a host to ViPR
    #
    # @param host_payload [JSON] New host information
    # @return [JSON] returns host information
    # @author Kendrick Coleman
    def add_host(host_type=nil, ip_or_dns=nil, name=nil, user_name=nil, password=nil, port=nil, use_ssl=nil, discoverable=nil, auth=nil, cert=nil)
        check_host_post(host_type, ip_or_dns, name, user_name, password)
        host_type = host_type.split('_').collect(&:capitalize).join

        if host_type == "Windows" 
            use_ssl.nil? ? use_ssl = false : use_ssl
            if use_ssl == true
                port.nil? ? port = '5986' : port
            else
                port.nil? ? port = '5985' : port
            end
            discoverable.nil? ? discoverable = true : discoverable
            user_name.nil? ? user_name = "admin" : user_name
            password.nil? ? password = "#1Password" : password
        elsif host_type == "Linux"
            use_ssl.nil? ? use_ssl = false : use_ssl
            port.nil? ? port = '22' : port = port
            discoverable.nil? ? discoverable = true : discoverable
            user_name.nil? ? user_name = "admin" : user_name
            password.nil? ? password = "#1Password" : password
        elsif host_type == "Hpux"
            host_type = "HPUX"
        end
        rest_post(generate_host_post_json(host_type, ip_or_dns, name, port, user_name, password, use_ssl, discoverable), "#{@base_url}/tenants/#{@tenant_uid}/hosts", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end

    # Add an initiator to a host in ViPR
    #
    # @param initiator_payload [JSON] New initiator information in JSON format
    # @param host_href [STRING] HREF value of a host
    # @return [JSON] returns initiator information
    # @author Craig J Smith
    def add_host_initiator(host_id=nil, protocol=nil, initiator_port=nil, initiator_node=nil, auth=nil, cert=nil)
        check_host_get(host_id)
        check_host_post_initiator(protocol, initiator_port)

        protocol = protocol.upcase
        if protocol == "ISCSI"
            protocol = "iSCSI"
        end
        initiator_payload_array = generate_initiators_json(protocol, initiator_node, initiator_port)
        initiator_payload_array.each do |i|
            rest_post(i, "#{@base_url}/compute/hosts/#{host_id}/initiators", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
        end
    end
  
    # Get all Host objects in ViPR
    #
    # @return [JSON] returns a JSON collection of all hosts in ViPR for a particular tenant
    # @author Craig J Smith
    def get_all_hosts(auth=nil, cert=nil)
        rest_get("#{@base_url}/tenants/#{@tenant_uid}/hosts", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end
  
    # Get an individual host's details in ViPR
    #
    # @param host_href [STRING] HREF value of a host
    # @return [JSON] returns host information
    # @author Craig J Smith
    def get_host(host_id=nil, auth=nil, cert=nil)
        check_host_get(host_id)
        rest_get("#{@base_url}/compute/hosts/#{host_id}", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end
  
    # Deactive a host
    #
    # @param host_href [STRING] HREF value of a host
    # @return [JSON] returns ... information
    # @author Craig J Smith
    def deactivate_host(host_id=nil, auth=nil, cert=nil)
        check_host_get(host_id)
        rest_post(nil, "#{@base_url}/compute/hosts/#{host_id}/deactivate", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end
  
    # Detirmine if a host already exists in ViPR
    #
    # @param hostname [STRING] The name of the host to search for
    # @return [BOOLEAN] returns TRUE/FALSE 
    # @author Kendrick Coleman
    def host_exists?(hostname, auth=nil, cert=nil)
        hostname = hostname.downcase
        host_array = []
        hosts = get_all_hosts
        hosts.each do |key, value|
          value.each do |k|
            host_array << k['name'].to_s.downcase
          end
        end
       host_array.include?(hostname) 
    end
  
    # Find and return query results for a host in ViPR
    #
    # @param search_param [STRING] Value to search host for
    # @return [JSON] returns search results
    # @author Craig J Smith
    def find_host_object(search_param, auth=nil, cert=nil)
      rest_get("#{@base_url}/compute/hosts/search?name=#{search_param}", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end

    #############################################################
    # Error Handling method to make sure params are there
    ##############################################################
    def check_host_post(host_type, ip_or_dns, name, user_name, password)
      if host_type == nil || ip_or_dns == nil || name == nil
          raise "Missing a Required param (host_type, ip_or_dns, name)"
      end
    end

    def check_host_get(host_id)
      if host_id == nil
          raise "Missing the Required param (host_id). Find the host_id by using the get_all_hosts method."
      end
    end

    def check_host_post_initiator(protocol, initiator_port)
      if protocol== nil || initiator_port == nil
          raise "Missing the Required param (protocol or initiator_port)."
      end
    end

end