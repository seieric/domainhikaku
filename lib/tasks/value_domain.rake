namespace :value_domain do
  desc "バリュードメインから料金を取得"

  task :get => :environment do
    #各ドメイン料金を1配列に集約
    jp = jp_prices
    gtld = gtld_prices
    newgtld = newgtld_prices
    cctld = cctld_prices
    update_prices = jp.merge(gtld).merge(newgtld).merge(cctld)
    register_prices = register

    prices = update_prices.merge(register_prices)  do |key, updated, registered|
      [registered, updated]
    end

    p prices

    #register = DataRegister.new
    #register.start(prices, 1)
  end

  @agent = Mechanize.new

  def register
    page = @agent.get("https://www.value-domain.com/searchdomain.php?viewtype=all")
    prices =  page.search("div.clearfix span.price")
    domains =  page.search("ul.domSpecies li.wait")

    domain_list = []
    register_list = []

    prices.each do |price|
      register_list << price.inner_text.gsub(",","").to_i
    end

    domains.each do |domain|
      if domain.get_attribute(:id) == "xn--tckwe"
        domain =  ".コム"
        domain_list << domain
        next
      end
      if domain.get_attribute(:id) == "jp_puny"
        domain = "/ja-jp/.jp"
        domain_list << domain
        next
      end

      domain_list <<  "." + domain.get_attribute(:id).gsub("_",".")
    end

    domain_list.zip(register_list).to_h
  end

  def cctld_prices
    page = @agent.get("https://www.value-domain.com/domlist.php?dom_type=ccTLD")
    domains =  page.search("table.tbPrice td.bold")
    prices = page.search("td.center")

    domain_list = []
    update_list = []

    domains.each do |domain|
      domain_list << domain.inner_text
    end

    prices.each_with_index do |price, i|
      next if i % 3 != 0
      update_list << price.inner_text.gsub(",","").to_i
    end

    domain_list.zip(update_list).to_h
  end

  def gtld_prices
    page = @agent.get("https://www.value-domain.com/domlist.php?dom_type=gTLD")
    domains =  page.search("table.tbPrice td.bold")
    prices = page.search("td.center")

    domain_list = []
    update_list = []

    domains.each do |domain|
      domain_list << domain.inner_text
    end

    prices.each_with_index do |price, i|
      next if i % 3 != 0
      update_list << price.inner_text.gsub(",","").to_i
    end

    domain_list.zip(update_list).to_h
  end

  def jp_prices
    page = @agent.get("https://www.value-domain.com/domlist.php?dom_type=JP")
    domains =  page.search("table.tbPrice td.bold")
    prices = page.search("td.center")

    domain_list = []
    update_list = []

    domains.each do |domain|
      domain = domain.inner_text
      if domain.include?("（ローマ字）")
        domain = domain.gsub("（ローマ字）","")
      end
      if domain.include?("（日本語）")
        domain = domain.gsub("（日本語）","")
        domain = "/ja-jp/" + domain
      end

      domain_list << domain
    end

    prices.each_with_index do |price, i|
      break if i > 9
      next if i % 3 != 0 || i == 6
      update_list << price.inner_text.gsub(/[^0-9]/,"").to_i
    end

    update_prices = domain_list.zip(update_list).to_h
    update_prices[".or.jp"] = update_prices[".co.jp"]

    update_prices
  end

  def newgtld_prices
    page = @agent.get("https://www.value-domain.com/domlist.php?dom_type=New_gTLD")
    domains =  page.search("table.tbPrice td.bold")
    prices = page.search("td.center")

    domain_list = []
    update_list = []

    domains.each do |domain|
      domain_list << domain.inner_text
    end

    prices.each_with_index do |price, i|
      next if i % 3 != 0
      update_list << price.inner_text.gsub(",","").to_i
    end

    domain_list.zip(update_list).to_h
  end
end
