class LimelightController < ApplicationController
 
	require 'htmlentities'

	attr_accessor :auth_url
  def mobile 
		url =  "http://api.delvenetworks.com/rest/organizations/817cef3499c347e081390856b75cf994/channels/c862458174184736a2538fa51b859596/mobile_url/MobileH264.xml"
		@auth_url =HTMLEntities.new.decode authenticate_request( 'get', url, 'PwUAGw7IiTFecDrTJTr8mYaPPgo=', 'p3MkuBktJ0/bGDzrbfsSOdKKUH0=')
  end

	require 'base64'
  require 'hmac-sha2' # gem install ruby-hmac

  def authenticate_request(http_verb, resource_url, access_key, secret, params = {})
    params = params != nil ? params.clone : {}
    params["access_key"] = access_key
    params["expires"] = 300.seconds.from_now.utc.to_i unless params["expires"] != nil && !params["expires"].blank?

    uri = URI.parse(resource_url)

    string_to_sign = [
            http_verb.to_s.downcase,
            uri.host.downcase,
            uri.path.downcase,
            params.sort.map{ |arr| arr.join('=') }.join('&')
    ].join('|')

    params["signature"] = Base64.encode64(HMAC::SHA256::digest(secret, string_to_sign)).chomp

    qs = params.to_query
    qs.blank? ? resource_url : "#{resource_url}?#{qs}"

	end

end

