class Crawler
  def self.page url
    agent = Mechanize.new
    agent.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36"
    agent.get(url)
  end
end
