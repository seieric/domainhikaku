namespace :star_domain do
  desc "スタードメインから料金を取得する"
  class String
    REG_EXP = /円.*/m
    def format
      self.gsub(REG_EXP, "").gsub(",", "").strip.to_i
    end

    def to_rep
      self.gsub("(※取得条件)","").gsub("(ローマ字)", "").gsub("(日本語)","/ja-jp/").gsub("都道府県","/prefectures/")
    end
  end
  task :get => :environment do
    agent = Mechanize.new
    page = agent.get("https://www.star-domain.jp/price/")
    records = page.search("table tr")
    agent.shutdown

    records = records.slice(1..-1) #見出し行を削除

    renewal = {} #更新料金
    registration = {} #取得料金

    records.each do |r|
      type = r.xpath("td[1]").text
      domain = r.xpath("th").text.to_rep
      price = r.xpath("td[2]").text.format
      if type.include?("取得") && type.include?("更新")
        renewal[domain] = price
        registration[domain] = price
      elsif type.include?("取得")
        registration[domain] = price
      elsif type.include?("更新")
        if domain.empty?
          next if registration.keys.last == renewal.keys.last
          renewal[registration.keys.last] = price
        end
      end
    end

    prices = renewal.merge(registration) do |key, renew, regist|
      [regist, renew]
    end

    p prices
    DataRegister.start(prices, 4)
  end
end
