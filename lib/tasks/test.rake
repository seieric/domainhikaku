namespace :test do
  desc "Test Task"

  task :get do
    agent = Mechanize.new
    agent.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36"
    page = agent.get("https://www.onamae.com/service/d-regist/price.html")
    p page.body.encoding
    html =  page.body
    File.open("tmp.html","w:ASCII-8BIT:UTF-8") do |file|
      file.puts(html)
      p "File"
    end
  end
end
