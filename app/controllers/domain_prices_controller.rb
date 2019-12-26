class DomainPricesController < ApplicationController
  def index
    @price = DomainPrice.page(params[:page]).per(13)
  end

  def edit
    @price = DomainPrice.find(:id)
  end
end
