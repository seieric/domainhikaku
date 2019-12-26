namespace :muumuu_domain do
  desc "ムームドメインから料金を取得"

  task :get => :environment do
    agent = Mechanize.new
    page = agent.get("https://muumuu-domain.com/domain/price")

    domains =  page.search("span.muu-text-size--em-large")
    prices = page.search("span.muu-numerical-value__number")

    domain_list = []
    register_list = []
    update_list = []

    domains.each do |domain|
      domain = domain.inner_text
      domain_list << domain
    end

    prices.each_with_index do |price, i|
      next if (i - 2) % 3 == 0 #移管料金を削除
      price = price.inner_text.gsub(",", "").to_i
      update_list << price if (i - 1) % 3 == 0
      register_list << price if i % 3 == 0
    end

    register_prices = domain_list.zip(register_list).to_h
    update_prices = domain_list.zip(update_list).to_h

    prices = update_prices.merge(register_prices)  do |key, updated, registered|
      [registered, updated]
    end

    p prices
    
    register = DataRegister.new
    register.start(prices, 2)
  end
end
