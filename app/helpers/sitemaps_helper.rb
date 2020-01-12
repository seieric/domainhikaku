module SitemapsHelper
  def daily
    @today - 1
  end
  def monthly
    @today.strftime("%Y-%m-01")
  end
  def yearly
    @today.strftime("%Y-01-01")
  end
end
