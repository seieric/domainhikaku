namespace :x_domain do
  desc "Xdomainから料金を取得"

  task :get_prices => :environment do
    agent = Mechanize.new
    page = agent.get("https://www.xdomain.ne.jp/domain/price.php")

    prices =  page.search("#domainPriceTable td.price_td")
    domains =  page.search("#domainPriceTable th.sub_th")

    domain_list = []
    register_list = []
    update_list = []

    domains.each do |domain|
      domain_list << domain.inner_text
    end

    prices.each_with_index do |price, i|
      price = price.inner_text.gsub(" ","").gsub("\n","").gsub("円","").gsub(",","").to_i

      if i <= 24
         if i % 2 == 0
           register_list << price
         else
           update_list << price
         end

         next
      end

      register_list << price
      update_list << price
    end

    register_prices = domain_list.zip(register_list).to_h
    update_prices = domain_list.zip(update_list).to_h

    prices = update_prices.merge(register_prices)  do |key, updated, registered|
      [registered, updated]
    end

    p prices

    register = DataRegister.new
    register.start(prices, 0)
  end
end
