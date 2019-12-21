class RemoveNotNull < ActiveRecord::Migration[6.0]
  def up
    change_column_null :domain_prices, :domain, true
    change_column_null :domain_prices, :price, true
    change_column_null :domain_prices, :registrar, true
  end

  def down
    change_column_null :domain_prices, :domain, false
    change_column_null :domain_prices, :price, false
    change_column_null :domain_prices, :registrar, false
  end
end
