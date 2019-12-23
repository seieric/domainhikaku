namespace :onamae_com do
  desc "お名前.comから料金を取得"

  task :get_prices => :environment do
    update_prices = update
    register_prices = register

    prices = update_prices.merge(register_prices)  do |key, updated, registered|
      [registered, updated]
    end
    register = DataRegister.new
    register.start(prices, 3)
  end

  def update
    session = Selenium::WebDriver.for :safari
    session.navigate.to "https://www.onamae.com/service/d-renew/price.html#gtld"
    records = session.find_elements(:css, "table.tablePricing tr")

    formats = {
      "日本語" => "(日本語)",
      "都道府県型" => "(都道府県)",
      "(***.ローマ字.jp)" => "",
      "(***.(日本語).jp)" => ""
    }
    prices = []
    records.each do |d|
      record = d.text.gsub("\t","").gsub("\r","").gsub("\n","")
      set = [record.slice(/^[^0-9]+/), record.slice(/[0-9[,]]+円/)]
      if set.include?(nil) || set.include?("属性型com/net/org")
        next
      else
        set[-1] = set[-1].gsub("円","").gsub(",","").to_i
        formats.each do |before, after|
          set[0].gsub!(before, after)
        end
        prices << set
      end
    end

    Hash[*prices.flatten]
  end
  def register
    agent = Mechanize.new
    page = agent.get("https://www.onamae.com/service/d-regist/price.html")

    domain_list = []
    price_list = []
    4.times do |i|
      domains = page.search("table.d0#{i+1} td")
      prices = page.search("table.regist0#{i+1} td")
      formats ={
        " " => "",
        "\n" => "",
        "\t" => "",
        "\r" => "",
        "日本語" => "(日本語)",
        "都道府県型" => "(都道府県)",
        "(***.ローマ字.jp)" => "",
        "(***.(日本語).jp)" => ""
      }
      domains.each do |d|
        d = d.text
        formats.each do |before, after|
          d = d.gsub(before, after)
        end
        domain_list << d
      end
      prices.each_with_index do |p, j|
        next unless j % 10 == 0
        price_list << p.text.gsub("円","").gsub(",","").to_i
      end
    end
    del_index = domain_list.find_index {|v| v == "属性型com/net/org"}
    domain_list.delete_at(del_index)
    price_list.delete_at(del_index)

    domain_list.zip(price_list).to_h
  end
end
