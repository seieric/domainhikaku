namespace :onamae_com do
  desc "お名前.comから料金を取得する"

  task :get => :environment do
    agent = Mechanize.new
    agent.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36"
    page = agent.get("https://www.onamae.com/service/d-regist/price.html")

    replace = {
      "\n" => "",
      "\r" => "",
      "\t" => "",
      " " => "",
      "都道府県型.jp(***.ローマ字.jp)" => "./prefectures/.jp",
      "都道府県型.jp(***.日本語.jp)" => "./prefectures/ja-jp/.jp",
      "日本語" => "/ja-jp/"
    }
    price_list = []
    domain_list = []

    domains = page.search("td.domain")
    domains.each do |d|
      d = d.text
      replace.each{|before, after| d.gsub!(before, after)}
      domain_list << d
    end
    domain_list.slice!(domain_list.rindex(".com")..-1)

    4.times do |i|
      prices = page.search("table.regist0#{i+1} td")
      prices.each_with_index do |p, j|
        next unless j % 10 == 0
        price_list << p.text.gsub(/[^0-9]/,"").to_i
      end
    end

    register_prices = domain_list.zip(price_list).to_h
    bin_path = ENV.fetch("GOOGLE_CHROME_BIN")
    options = Selenium::WebDriver::Chrome::Options.new(
      binary: bin_path,
      args: ["--headless", "--disable-gpu", "--no-sandbox", "window-size=1280x800", "--remote-debugging-port=9222"]
    )
    session = Selenium::WebDriver.for :chrome, options: options
    session.navigate.to "https://www.onamae.com/service/d-renew/price.html#gtld"
    records = session.find_elements(:css, "table.tablePricing tr")

    update_prices = []
    records.each do |d|
      record = d.text.gsub("\t","").gsub("\r","").gsub("\n","")
      set = [record.slice(/^[^0-9]+/), record.slice(/[0-9[,]]+円/)]
      next if set.include?(nil)
      replace.each{|before, after| set[0].gsub!(before, after)}
      set[-1] = set[1].gsub(/[^0-9]/,"").to_i
      update_prices << set
    end
    update_prices = Hash[*update_prices.flatten]

    prices = update_prices.merge(register_prices) do |key, update, register|
      [register, update]
    end

    DataRegister.start(prices, 3)
    agent.shutdown
    session.quit
  end
end
