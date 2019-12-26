class DomainPricesController < ApplicationController
  def index
    @prices = DomainPrice.page(params[:page]).per(20)
  end
end
