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
      
    def generate_initiators_json
        initiator_json = []
        @initiators_port.each do |initiator|
          initiator_json <<
          {
            protocol: @protocol.upcase,
            initiator_port: initiator,
            initiator_node: @initiator_node
          }.to_json
        end
        initiator_json
    end
    # Add a host to ViPR
    #
    # @param host_payload [JSON] New host information
    # @return [JSON] returns host information
    # @author Kendrick Coleman
    def add_host(host_type=nil, ip_or_dns=nil, name=nil, user_name=nil, password=nil, port=nil, use_ssl=nil, discoverable=nil, auth=nil, cert=nil)
        check_host_post(host_type, ip_or_dns, name, user_name, password)
        host_type.camelize
        puts host_type

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
=begin 
    # Add an initiator to a host in ViPR
    #
    # @param initiator_payload [JSON] New initiator information in JSON format
    # @param host_href [STRING] HREF value of a host
    # @return [JSON] returns initiator information
    # @author Craig J Smith
    def add_initiator(initiator_payload,host_href, auth=nil, cert=nil)
      rest_post(initiator_payload, "#{@base_url}#{host_href}/initiators", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end
  
    # Get all Host objects in ViPR
    #
    # @return [JSON] returns a JSON collection of all hosts in ViPR
    # @author Craig J Smith
    def get_all_hosts(auth=nil, cert=nil)
      rest_get("#{@base_url}/tenants/#{@tenant_uid}/hosts", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end
  
    # Get an individual host's details in ViPR
    #
    # @param host_href [STRING] HREF value of a host
    # @return [JSON] returns host information
    # @author Craig J Smith
    def get_host(host_href, auth=nil, cert=nil)
      rest_get("#{@base_url}#{host_href}", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end
  
    # Deactive a host
    #
    # @param host_href [STRING] HREF value of a host
    # @return [JSON] returns ... information
    # @author Craig J Smith
    def deactivate_host(host_href, auth=nil, cert=nil)
      rest_post(nil, "#{@base_url}#{host_href}/deactivate", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end

    # Add a host and it's initiators (Need to change param values)
    #
    # @param host [OBJECT] host object
    # @return [JSON] returns host information
    # @author Craig J Smith
    #def add_host_and_initiators(host)
    #  host_href = add_host(host.generate_json)['resource']['link']['href']
    #  host.generate_inistiators_json.each do |initiator|
    #    add_initiator(initiator,host_href)
    #  end
    #end
  
    # Detirmine if a host already exists in ViPR
    #
    # @param hostname [STRING] The name of the host to search for
    # @return [BOOLEAN] returns TRUE/FALSE 
    # @author Craig J Smith
    def host_exists?(hostname, auth=nil, cert=nil)
      find_host_object(hostname)['resource'].any?
    end
  
    # Find and return query results for a host in ViPR
    #
    # @param search_param [STRING] Value to search host for
    # @return [JSON] returns search results
    # @author Craig J Smith
    def find_host_object(search_param, auth=nil, cert=nil)
      rest_get("#{@base_url}/compute/hosts/search?name=#{search_param}", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end
=end
    #############################################################
    # Error Handling method to make sure params are there
    ##############################################################
    def check_host_post(host_type, ip_or_dns, name, user_name, password)
      if host_type == nil || ip_or_dns == nil || name == nil
          raise "Missing a Required param (host_type, ip_or_dns, name)"
      end
    end

end