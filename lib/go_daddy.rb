class GoDaddy
  @headers = {
    "Authorization" => "sso-key #{ENV.fetch("GODADDY_API_KEY")}:#{ENV.fetch("GODADDY_API_SECRET")}",
    "Accept" => "applicaton/json"
  }
  def self.is_available?(domain)
    domain = SimpleIDN.to_ascii(domain)
    param = URI.encode_www_form(domain: domain)
    uri = URI.parse("https://api.godaddy.com/v1/domains/available?#{param}")
    req = Net::HTTP::Get.new(uri.request_uri)
    req.initialize_http_header(@headers)
    begin
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme === "https"
      response = http.request(req)

      if response.code == "200"
        data = JSON.parse(response.body)
        data['available'] #return1
      else
        nil #return2
      end
    rescue IOError => e
      logger.error(e.full_message) #return3
    end
  end
end
