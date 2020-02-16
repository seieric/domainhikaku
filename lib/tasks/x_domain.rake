namespace :x_domain do
  desc "Xdomainから料金を取得"

  task :get => :environment do
    page = Crawler.page("https://www.xdomain.ne.jp/domain/price.php")

    prices =  page.search("#domainPriceTable td.price_td")
    domains =  page.search("#domainPriceTable th.sub_th")

    domain_list = []
    price_list = []
    formats = {
      "(ローマ字)" => "",
      "(日本語)" => "/ja-jp/",
      "都道府県" => "/prefectures/"
    }
    domains.each do |domain|
      domain = domain.inner_text
      formats.each{|before, after| domain.gsub!(before, after)}
      domain_list << domain
    end

    trigger = (prices.length - domains.length)
    prices.each_slice(2).with_index do |price, i|
      a = price[0].inner_text.gsub(" ","").gsub("\n","").gsub("円","").gsub(",","").to_i
      b = price[-1].inner_text.gsub(" ","").gsub("\n","").gsub("円","").gsub(",","").to_i
      if i <= trigger - 1
        price_list << [a, b]
      else
        price_list << [a, a] << [b, b]
      end
    end
    list = domain_list.zip(price_list).to_h
    DataRegister.start(list, 0)
  end
end
