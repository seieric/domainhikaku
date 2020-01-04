class ChartsController < ApplicationController
  include PublicSuffix #mixin
  def index
    if params[:domain].empty?
      redirect_to root_url
      return
    end
    if PublicSuffix.valid?(params[:domain], default_rule: nil)
      @domain = PublicSuffix.parse(params[:domain])
    else
      @domain = params[:domain] + ".com"
      @domain = PublicSuffix.parse(@domain)
    end
    tld = "." + @domain.tld
    @prices = DomainPrice.where(domain: tld)
    data = []
    @prices.each_with_index do |p, i|
      now = Date.today
      data[i] = {now.strftime("%Y-%m-%d") => p.register_price}
      tmp = Hash.new
      (1..5).each do |j|
        tmp[now.since(j.years).strftime("%Y-%m-%d")] = p.register_price + p.update_price * j
      end
      tmp["name"] = p.registrar
      tmp["domain"] = p.domain
      data[i].merge!(tmp)
    end
    @data = Array.new
    data.each_with_index do |d, i|
      name = "#{d["name"]} #{d["domain"]}"
      d.delete("name")
      d.delete("domain")
      @data << {name: name, data: d}
    end
  end
end