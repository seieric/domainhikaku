namespace :star_domain do
  desc "スタードメインから料金を取得する"
  class String
    REG_EXP = /円.*/m
    def format
      self.gsub(REG_EXP, "").gsub(",", "").strip.to_i
    end

    def to_rep
      self.gsub("(※取得条件)","").gsub("(ローマ字)", "").gsub("(日本語)","").gsub("都道府県","")
    end
  end

  task :get => :environment do
    page = Crawler.page("https://www.star-domain.jp/price/")

    records = page.search("table tr")
    records = records.slice(1..-1) #見出し行を削除

    Crawler.quit!

    records.each do |r|
      type = r.xpath("td[1]").text
      th = r.xpath("th").text
      if th.include?("日本語") #日本語ドメインを指定
        lang = "ja"
      else
        lang = "en"
      end
      next if th.include?("都道府県") #都道府県ドメインは登録しない
      domain = th.to_rep
      price = r.xpath("td[2]").text.format
      if type.include?("取得") && type.include?("更新")
        renewal = price
        registration = price
      elsif type.include?("取得")
        tmp_price = price #取得料金をtmp_priceに保存
        tmp_domain = domain #更新料金をtmp_domainに保存
        next #次のレコードへ
      elsif type.include?("更新")
        if domain.empty? && tmp_domain == domain
          renewal = price
          registration = tmp_price
        else
          next
        end
      end

      DataRegister.add(domain, lang, registration, renewal, 4)
    end
  end
end
