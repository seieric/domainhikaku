class ChartsController < ApplicationController
  include PublicSuffix #mixin
  def index
    param = params[:domain]

    if param.empty?
      redirect_to root_url
    else
      if PublicSuffix.valid?(param) #ドメイン名として有効か？
        @domain = PublicSuffix.parse(param, ignore_private: true)
        @tld = "." + @domain.tld
      elsif param.start_with?(".") #TLDのみの入力か？
        @tld = param
      else
        @domain = PublicSuffix.parse(param + ".com", ignore_private: true)
        @tld = "." + @domain.tld
      end

      @prices = Rails.cache.fetch("cache-#{@tld}", expired_in: 120.minutes) do
        DomainPrice.where(domain: @tld).to_a
      end

      data = []
      @min_regist = @prices[0].register_price
      @min_renewal = @prices[0].update_price
      @prices.each_with_index do |p, i|
        now = Date.today

        data[i] = {now.strftime("%Y-%m-%d") => p.register_price}
        tmp = {}
        (1..5).each do |j|
          tmp[now.since(j.years).strftime("%Y-%m-%d")] = p.register_price + p.update_price * j
        end

        tmp["name"] = view_context.show_registrar(p.registrar)
        tmp["domain"] = p.domain
        data[i].merge!(tmp)

        @min_regist = p.register_price if p.register_price < @min_regist
        @min_renewal = p.update_price if p.update_price < @min_renewal
      end
      @data = []
      data.each_with_index do |d, i|
        name = "#{d["domain"]} | #{d["name"]} "
        d.delete("name")
        d.delete("domain")
        @data << {name: name, data: d}
      end
    end
  end
end
