module ChartsHelper
  def show_price_regist(price)
    if price == @min_regist
      "<td class='cheapest'>#{price.to_s(:delimited)}</td>"
    else
      "<td>#{price.to_s(:delimited)}</td>"
    end
  end

  def show_price_renewal(price)
    if price == @min_renewal
      "<td class='cheapest'>#{price.to_s(:delimited)}</td>"
    else
      "<td>#{price.to_s(:delimited)}</td>"
    end
  end
end
