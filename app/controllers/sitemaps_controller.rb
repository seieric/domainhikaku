class SitemapsController < ApplicationController
  def index
    @site_domain = "https://#{request.host}"
    @domains = DomainPrice.select("domain").distinct.order("domain").reject do |e|
      e.domain !~ /^\.[a-z]+$/ || e.domain.include?("/")
    end
    @today = Date.today
  end
end
