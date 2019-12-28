require __dir__ + '/env/api_keys'
class GoDaddy
  def self.is_available?(domain)
    domain = SimpleIDN.to_ascii(domain)
    param = URI.encode_www_form(domain: domain)
    uri = URI.parse("https://api.godaddy.com/v1/domains/available?#{param}")
    req = Net::HTTP::Get.new(uri.request_uri)
    req.initialize_http_header(@headers)
    begin
      response = Net::HTTP.new(uri.host, uri.port) do |http|
        http.use_ssl = uri.scheme === "https"
        http.open_timeout = 5
        http.read_timeout = 10
        http.request(req)
      end

      if response.code = 200
        data = JSON.parse(response.body)
        data['available']
      end
    rescue IOError => e
      logger.error(e.full_message)
    end
  end
  def initialize
    @headers = {
      "Authorization" => "sso-key #{API_KEY}:#{API_SECRET}",
      "Accept" => "applicaton/json"
    }
  end
end
