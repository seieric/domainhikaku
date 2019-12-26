class DomainPricesController < ApplicationController
  def index
    @prices = DomainPrice.page(params[:page]).per(13)
  end
end
