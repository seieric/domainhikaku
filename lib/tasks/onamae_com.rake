namespace :onamae_com do
  desc "お名前.comから料金を取得"

  task :get_prices => :environment do
    update_prices = update
    register_prices = register
    p update_prices.length
    p register_prices.length

    prices = update_prices.merge(register_prices)  do |key, updated, registered|
      [registered, updated]
    end

    prices.each{|p| p p}
    p prices.length
  end

  def update
    session = Selenium::WebDriver.for :safari
    session.navigate.to "https://www.onamae.com/service/d-renew/price.html#gtld"
    records = session.find_elements(:css, "table.tablePricing tr")

    prices = []
    replace = {
      "日本語" => "/ja-jp/",
      "都道府県型.jp(***.ローマ字.jp)" => "./prefectures/.jp",
      "都道府県型.jp(***./ja-jp/.jp)" => "./prefectures/ja-jp/.jp"
    }
    records.each do |d|
      record = d.text.gsub("\t","").gsub("\r","").gsub("\n","")
      set = [record.slice(/^[^0-9]+/), record.slice(/[0-9[,]]+円/)]

      next if set.include?(nil) || set.include?("属性型com/net/org")

      replace.each{|before, after| set[0].gsub!(before, after)}
      set[-1] = set[-1].gsub(/[^0-9]/,"").to_i
      prices << set
    end

    Hash[*prices.flatten]
  end

  def register
    agent = Mechanize.new
    agent.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36"
    page = agent.get("https://www.onamae.com/service/d-regist/price.html")

    price_list = []
    domain_list = []

    replace = {
      "\n" => "",
      "\r" => "",
      "\t" => "",
      " " => "",
      "都道府県型.jp(***.ローマ字.jp)" => "./prefectures/.jp",
      "都道府県型.jp(***.日本語.jp)" => "./prefectures/ja-jp/.jp",
      "日本語" => "/ja-jp/"
    }
    prefecture_count = 0
    domains = page.search("td.domain")
    domains.each do |d|
      domain = d.text
      replace.each{|before, after| domain.gsub!(before, after)}
      domain_list << domain
    end
    domain_list.slice!(domain_list.rindex(".com")..-1)

    4.times do |i|
      prices = page.search("table.regist0#{i+1} td")
      prices.each_with_index do |p, j|
        next unless j % 10 == 0
        price_list << p.text.gsub(/[^0-9]/,"").to_i
      end
    end

    target = domain_list.index("属性型com/net/org")
    domain_list.delete_at(target)
    price_list.delete_at(target)

    domain_list.zip(price_list).to_h

    page.body
  end
end
