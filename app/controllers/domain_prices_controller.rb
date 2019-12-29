class DomainPricesController < ApplicationController
  def index
    @price = DomainPrice.page(params[:page]).per(10).search(params[:q])
    @search = params[:q]
  end
end
